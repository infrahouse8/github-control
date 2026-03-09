# GitHub Organization Controller — Unification & Scaling Plan

## Problem Statement

The github-control repo manages ~70 GitHub repos via a single monolithic Terraform state.
CI runs a single `terraform plan` that refreshes all ~1000+ resources against GitHub/AWS APIs.
This takes ~10 minutes today and scales linearly — 10x repos means 10x plan time.

## Current Architecture

```
1 Terraform state = everything
  - org settings, teams, membership
  - 70+ repos (repository, files, rulesets, secrets, team access)
  - IAM roles, state buckets
  - secrets management
```

Every PR — even one that adds a single repo — plans the entire state.

## Target Architecture: One State Per Repo

### Star Topology

```
            ┌─────────────────┐
            │    Org Core     │
            │    (1 state)    │
            │                 │
            │ - org settings  │
            │ - teams         │
            │ - membership    │
            │ - org secrets   │
            └────────┬────────┘
                     │
                     │ terraform_remote_state / data sources
                     │
      ┌──────────────┼─────────────┬─────────────┐
      │              │             │             │
  ┌───▼───┐    ┌─────▼───┐    ┌────▼────┐    ┌───▼───┐
  │Repo A │    │ Repo B  │    │ Repo C  │    │Repo D │
  │ state │    │  state  │    │  state  │    │ state │
  └───────┘    └─────────┘    └─────────┘    └───────┘
```

- Repos never reference each other — they are fully independent.
- Each repo state only needs team IDs and org-level outputs from the core state.
- The core state is small and rarely changes.
- Plan time per repo is O(1) — ~10-20 seconds regardless of total repo count.

### What Each Repo State Manages

- `github_repository`
- `github_repository_file` resources (file injection)
- `github_repository_ruleset` / branch protection
- `github_team_repository` (team access)
- `github_actions_secret`
- For service repos: IAM roles + state buckets per environment

### What Org Core State Manages

- `github_organization_settings`
- `github_team` resources
- `github_team_members`
- `github_membership`
- Org-level secrets (AWS Secrets Manager lookups)
- Outputs: team IDs, secret values, org-level config

## Orchestrator Design

Pure Terraform + a thin orchestrator (shell or Python).

### Recommended Approach: Shared Root Module + Backend Config

One shared Terraform root module for repos, parameterized per repo.
Each repo gets a different state key via `-backend-config`.

```bash
# Plan a single repo
plan_repo() {
    local repo=$1
    terraform init \
        -backend-config="key=repos/${repo}/terraform.tfstate" \
        -reconfigure
    terraform plan -var-file="repos/${repo}.tfvars"
}

# CI: plan only changed repos in parallel
changed_repos=$(detect_changed_repos)
parallel plan_repo ::: $changed_repos
```

### Directory Structure

```
github-control/
├── org-core/                    # Org-level resources (own state)
│   ├── main.tf                  # org settings
│   ├── teams.tf                 # teams + membership
│   ├── secrets.tf               # org-level secrets
│   ├── outputs.tf               # team IDs, secret values
│   └── terraform.tf             # backend: key=org-core/terraform.tfstate
│
├── repo-module/                 # Shared module (not a root module)
│   ├── repos.tf                 # github_repository
│   ├── repos-files.tf           # file injection
│   ├── rulesets.tf              # branch protection
│   ├── variables.tf             # repo config inputs
│   ├── files/                   # template files to inject
│   └── terraform.tf             # provider requirements
│
├── repo/                        # Root module for per-repo plans
│   ├── main.tf                  # calls repo-module, reads org-core state
│   ├── variables.tf             # repo-specific vars
│   └── terraform.tf             # backend (key set via -backend-config)
│
├── repos/                       # Per-repo variable files
│   ├── terraform-aws-vpc.tfvars
│   ├── terraform-aws-ecs.tfvars
│   ├── infrahouse-toolkit.tfvars
│   └── ...
│
├── scripts/
│   ├── plan-repo.sh             # Plan a single repo
│   ├── plan-changed.sh          # Detect changed repos, plan in parallel
│   ├── plan-all.sh              # Plan all repos (drift detection)
│   └── detect-changed-repos.sh  # Git diff parser
│
├── Makefile
└── .github/workflows/
    ├── terraform-CI.yml         # PR: plan changed repos in parallel
    ├── terraform-CD.yml         # Merge: apply changed repos
    └── terraform-drift.yml      # Nightly: plan all repos
```

### How Org-Core Outputs Reach Repo Plans

**Option 1: `terraform_remote_state` in the repo root module**

```hcl
# repo/main.tf
data "terraform_remote_state" "org_core" {
  backend = "s3"
  config = {
    bucket = "infrahouse-github-control-state"
    key    = "org-core/terraform.tfstate"
    region = "us-west-1"
  }
}

module "repo" {
  source = "../repo-module"

  team_id       = data.terraform_remote_state.org_core.outputs.dev_team_id
  admin_team_id = data.terraform_remote_state.org_core.outputs.admin_team_id
  # ...
}
```

**Option 2: Orchestrator reads core outputs, passes as -var flags**

```bash
# scripts/plan-repo.sh
TEAM_ID=$(cd org-core && terraform output -raw dev_team_id)
terraform plan -var="team_id=${TEAM_ID}" -var-file="repos/${repo}.tfvars"
```

Option 1 is simpler (self-contained, no orchestrator state). Option 2 avoids
the extra S3 read per repo plan but couples the orchestrator to core outputs.

Recommendation: **Option 1** — each repo plan reads org-core state directly.

### Change Detection in CI

```bash
# detect-changed-repos.sh
# Parse git diff to find which repo .tfvars files changed
git diff --name-only origin/main -- repos/ \
  | sed 's|repos/||; s|\.tfvars||' \
  | sort -u
```

For changes to the shared repo-module (file templates, rulesets, etc.),
plan ALL repos — the module change affects every repo.

```bash
if git diff --name-only origin/main | grep -q '^repo-module/'; then
    # Module changed — plan everything
    plan_all_repos
else
    # Only plan changed repos
    plan_changed_repos
fi
```

### Parallel Execution in CI

```yaml
# .github/workflows/terraform-CI.yml
jobs:
  detect:
    outputs:
      repos: ${{ steps.detect.outputs.repos }}
    steps:
      - id: detect
        run: |
          repos=$(scripts/detect-changed-repos.sh | jq -R -s -c 'split("\n") | map(select(. != ""))')
          echo "repos=${repos}" >> "$GITHUB_OUTPUT"

  plan:
    needs: detect
    strategy:
      matrix:
        repo: ${{ fromJSON(needs.detect.outputs.repos) }}
      max-parallel: 10
    steps:
      - run: scripts/plan-repo.sh ${{ matrix.repo }}
```

Each repo gets its own parallel CI job. GitHub Actions matrix handles fan-out.
Even with 1000 repos, if a PR changes 3 repos, only 3 jobs run (~20s each).

## Service Repo Concept — Generalized to N Environments

A service repo is a Terraform root module repo that deploys to multiple
AWS environments. Currently hardcoded to 2 (sandbox + production).

### Generalized Design

```hcl
# repos/aws-control-agentql.tfvars
repo_name   = "aws-control-agentql"
description = "AWS resources for AgentQL"
repo_type   = "service"

environments = {
  "sandbox" = {
    aws_account_id = "611021602836"
    region         = "us-west-1"
  }
  "staging" = {
    aws_account_id = "123456789012"
    region         = "us-west-1"
  }
  "production" = {
    aws_account_id = "722222646194"
    region         = "us-west-1"
  }
}
```

### What the Module Creates Per Environment

For each entry in `environments`:

1. **S3 state bucket**: `{org}-{env}-{repo_name}`
2. **DynamoDB lock table**: `{org}-{env}-{repo_name}-lock`
3. **IAM roles** (3 per environment):
   - `ih-tf-{repo_name}-{env}-github` (OIDC trust to GitHub Actions)
   - `ih-tf-{repo_name}-{env}-admin` (AdministratorAccess)
   - `ih-tf-{repo_name}-{env}-state-manager` (S3 + DynamoDB access)
4. **Injected files**:
   - `environments/{env}/terraform.tf` (backend config with env-specific bucket/table/role)
   - `environments/{env}/terraform.tfvars` (env-specific role ARNs)
5. **CI workflows**:
   - `terraform-CI.yml` with matrix over environments
   - `terraform-drift.yml` per environment
6. **Branch protection required checks**:
   - `"Terraform Plan {env}"` for each environment

### First PR in a New Service Repo

After github-control creates the repo, the very first PR in the new repo:
1. Adds Terraform resources under `environments/sandbox/` and `environments/production/`
2. CI runs `terraform plan` per environment (backend, roles, state already exist)
3. Merge triggers `terraform apply` per environment
4. Fully functional from day one — zero manual setup

## Productization Potential

### What This Becomes

**"GitHub Org Controller"** — a Terraform module that manages a GitHub
organization with O(1) plan time per repo, full CI/CD auto-provisioning,
and N-environment service repo support.

### Target Audience

Any team managing 10+ GitHub repos with Terraform that wants:
- Consistent repo configuration (files, workflows, branch protection)
- Auto-provisioned CI/CD for new Terraform repos
- Multi-environment support (dev/staging/prod) from a single declaration
- Plan times that don't degrade as repos grow

### Packaging

**Terraform module on registry.infrahouse.com** — users bring their own
state/providers and declarative repo config. The module + orchestrator
scripts handle everything else.

### Killer Feature

The service repo auto-provisioning: add one entry, get a GitHub repo with
N environments, each with its own state bucket, IAM roles, and CI/CD
workflows. First PR works end-to-end.

## Implementation Phases

### Phase 1: Extract the Repo Module
- Factor `modules/plain-repo` into a standalone, publishable module
- Clean up inputs: repo config as a single variable object
- Add `terraform_remote_state` data source for org-core

### Phase 2: Split Org Core
- Move org settings, teams, membership into `org-core/` root module
- Export team IDs and secrets as outputs
- Validate that repo module can read org-core state

### Phase 3: Per-Repo State + Orchestrator
- Create `repo/` root module that calls the repo module
- Generate `.tfvars` per repo from current `local.repos` map
- Write orchestrator scripts (plan-repo, detect-changed, plan-all)
- Update CI workflow to use matrix strategy

### Phase 4: Generalized Service Repos
- Add `var.environments` map to repo module
- Dynamic IAM role + state bucket creation per environment
- Template CI workflows with environment matrix
- Dynamic branch protection checks

### Phase 5: Productize
- Publish module to registry.infrahouse.com
- Documentation + examples
- Migrate both organizations to the shared module

## Performance Expectations

| Scenario | Current | After |
|----------|---------|-------|
| PR adds 1 repo | ~10 min | ~30s (1 plan job) |
| PR modifies 3 repos | ~10 min | ~30s (3 parallel jobs) |
| PR changes shared template | ~10 min | ~3-5 min (all repos in parallel matrix) |
| Nightly drift detection | ~10 min | ~3-5 min (all repos in parallel) |
| 1000 repos, PR adds 1 | hours | ~30s |
