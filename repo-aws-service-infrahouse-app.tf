# ============================================================
# InfraHouse product app — service repo
# ============================================================

# --- State bucket (one per repo, in the tfstates account) ---
module "aws_service_infrahouse_app_state" {
  source  = "registry.infrahouse.com/infrahouse/state-bucket/aws"
  version = "2.2.0"
  providers = {
    aws = aws.aws-289256138624-uw1
  }
  bucket = "infrahouse-github-control-aws-service-infrahouse-app"
}

# --- IAM roles (one gha-admin call per environment) ---
# Using 303467602807 as the sandbox workload account.
# aws.cicd points to the same account — github role lands there.
module "aws_service_infrahouse_app_gha_sandbox" {
  source  = "registry.infrahouse.com/infrahouse/gha-admin/aws"
  version = "3.6.1"
  providers = {
    aws          = aws.aws-303467602807-uw1
    aws.cicd     = aws.aws-303467602807-uw1
    aws.tfstates = aws.aws-289256138624-uw1
  }
  gh_org_name               = local.gh_org_name
  repo_name                 = "aws-service-infrahouse-app"
  state_bucket              = module.aws_service_infrahouse_app_state.bucket_name
  terraform_locks_table_arn = module.aws_service_infrahouse_app_state.lock_table_arn
}

# --- The service repo (pure GitHub, no AWS) ---
module "aws_service_infrahouse_app" {
  source = "./modules/service-repo"

  repo_name        = "aws-service-infrahouse-app"
  repo_description = "AWS infrastructure for the InfraHouse product app"
  gh_org_name      = local.gh_org_name
  github_app_slug  = "infrahouse-github-terraform"
  template_repo    = "terraform-root-template"
  state_bucket     = module.aws_service_infrahouse_app_state.bucket_name

  environments = {
    sandbox = {
      region                 = local.aws_default_region
      admin_role_arn         = module.aws_service_infrahouse_app_gha_sandbox.admin_role_arn
      github_role_arn        = module.aws_service_infrahouse_app_gha_sandbox.github_role_arn
      state_manager_role_arn = module.aws_service_infrahouse_app_gha_sandbox.state_manager_role_arn
      deploy_order           = 0
    }
  }

  pipeline_guardians       = github_team.admins.slug
  infrastructure_approvers = github_team.dev.slug
  release_managers         = github_team.admins.slug

  committers = {
    developers = github_team.dev.id
  }
  admins = {
    admins = github_team.admins.id
  }
}
