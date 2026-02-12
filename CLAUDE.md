# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## First Steps

**Your first tool call in this repository MUST be reading .claude/CODING_STANDARD.md.
Do not read any other files, search, or take any actions until you have read it.**
This contains InfraHouse's comprehensive coding standards for Terraform, Python, and general formatting rules.

## What This Repository Does

This is a Terraform Infrastructure-as-Code repository that manages the entire [InfraHouse](https://github.com/infrahouse) GitHub organization. 
It is the **source of truth** for organization settings, repositories, teams, membership, and secrets. 
All changes must go through pull requests — changes made outside this repo may be reverted.

The repository is hosted under the [infrahouse8](https://github.com/infrahouse8) user account (not the InfraHouse org) 
to ensure out-of-band management. Only `infrahouse8` has admin privileges in the organization.

## Common Commands

```bash
make bootstrap          # Install dev dependencies (Python packages + git hooks)
make bootstrap-ci       # Install CI-only dependencies
make hooks              # Install git pre-commit hooks (runs make lint)
make format             # Auto-format Terraform files
make lint               # Check YAML + Terraform formatting
make lint/validate      # Validate Terraform (requires init)
make init               # terraform init -upgrade
make plan               # terraform plan (outputs tf.plan, plan.stdout, plan.stderr)
make apply              # terraform apply from tf.plan
make clean              # Remove .terraform, lock file, plan files
make docs               # Build Sphinx HTML documentation
```

**Terraform version:** pinned in `.terraform-version` (currently 1.10.0).

## Architecture

### Providers

- **Two GitHub providers** (`provider.github.tf`): `infrahouse` (default, manages the org) and `infrahouse8` (aliased, manages the infrahouse8 user account). Both use GitHub App authentication (App ID 1016363).
- **Four AWS providers** (`provider.aws.tf`): CI/CD account (303467602807), Terraform state account (289256138624), management account (493370826424), primary account (990466748045). All us-west-1.

### Terraform Backend

S3 backend with DynamoDB state locking in the Terraform state account (289256138624). Configured in `terraform.tf`.

### Repository Management

Repositories are defined in `repos.tf` as a `local.repos` map. Each entry specifies a name, description, type, optional secrets, topics, and visibility. The `module "repos"` block iterates over this map using the `modules/plain-repo` module.

**Repository types** determine what gets injected:
- `terraform_module` — gets Claude agents, workflows (terraform-review, docs, release), SECURITY.md, CONTRIBUTING.md, LICENSE, Makefile-example, cliff.toml, pre-commit/commit-msg hooks, mkdocs config, terraform-docs config, TERRAFORM_MODULE_REQUIREMENTS.md, and an ANTHROPIC_API_KEY secret
- `terraform_aws` — gets AWS_DEFAULT_REGION secret
- `python_app` — gets AWS_DEFAULT_REGION secret
- `other` — base files only

**All repos** get: `renovate.json`, `vuln-scanner-pr.yml` workflow, `.claude/instructions.md`, `.claude/CODING_STANDARD.md`.

### File Injection

The `modules/plain-repo/repos-files.tf` uses `github_repository_file` resources to push standardized files into managed repositories. Template files live in `modules/plain-repo/files/`. Most use `overwrite_on_create = true` to stay in sync.

### Other Key Files

- `main.tf` — GitHub organization settings
- `teams.tf` — Team definitions (developers, admins)
- `membership.tf` — Dynamic org membership from `local.team_members` in `locals.tf`
- `secrets.tf` — AWS Secrets Manager integration (PYPI tokens, GitHub tokens, etc.)
- `infrahouse8_repos.tf` — Repos under the infrahouse8 user account + CI/CD module + GitHub Actions variables
- `data_sources.tf` — AWS data sources

### Modules

- `modules/plain-repo` — Core repo module: creates repository, team access, branch protection rulesets, action secrets, and injects standardized files
- `modules/local-repo` — For repos under the infrahouse8 user account
- `modules/repo-template` — Template repositories

## CI/CD

**CI** (`.github/workflows/terraform-CI.yml`): Runs on PRs. Lints, validates, runs `terraform plan`, publishes the plan as a PR comment via `ih-plan`, and uploads the plan file to S3.

**CD** (`.github/workflows/terraform-CD.yml`): Runs when PRs are merged. Downloads the approved plan from S3 and runs `terraform apply` — ensuring the exact reviewed plan is applied.

Both workflows use GitHub OIDC for AWS credential-less authentication.

## Adding a New Repository

Add an entry to the `local.repos` map in `repos.tf`:

```hcl
"repo-name" = {
  "description" = "Short description (single line, no control characters)"
  "type"        = "terraform_module"  # or terraform_aws, python_app, other
  "topics"      = ["optional", "topics"]
}
```

Optional fields: `secrets` (map of GitHub Actions secrets), `public_repo` (bool, default true), `auto_merge` (bool), `enable_pages` (bool, auto-enabled for terraform_module).

## Linting

The pre-commit hook runs `make lint` which checks:
- YAML formatting via `yamllint` (max line length 120, configured in `.yamllint`)
- Terraform formatting via `terraform fmt -check -recursive`

Always run `make format` before committing to fix Terraform formatting.

## Dependencies

- **Python** (`requirements.txt`): black, Sphinx, plus CI deps
- **Python CI** (`requirements-ci.txt`): boto3, infrahouse-toolkit (provides `ih-plan`), pyhcl, yamllint
- **Terraform providers**: github (integrations/github) 6.7.1, aws (hashicorp/aws) ~> 5.11
