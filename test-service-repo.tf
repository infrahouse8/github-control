# ============================================================
# Test service repo — safe to delete after validation
# ============================================================

# --- State bucket (one per repo, in the tfstates account) ---
module "test_service_state" {
  source  = "registry.infrahouse.com/infrahouse/state-bucket/aws"
  version = "2.2.0"
  providers = {
    aws = aws.aws-289256138624-uw1
  }
  bucket = "infrahouse-github-control-aws-service-test-delete-me"
}

# --- IAM roles (one gha-admin call per environment) ---
# Using 303467602807 as the sandbox workload account.
# aws.cicd points to the same account — github role lands there.
module "test_service_gha_sandbox" {
  source  = "registry.infrahouse.com/infrahouse/gha-admin/aws"
  version = "3.6.1"
  providers = {
    aws          = aws.aws-303467602807-uw1
    aws.cicd     = aws.aws-303467602807-uw1
    aws.tfstates = aws.aws-289256138624-uw1
  }
  gh_org_name               = "infrahouse"
  repo_name                 = "aws-service-test-delete-me"
  state_bucket              = module.test_service_state.bucket_name
  terraform_locks_table_arn = module.test_service_state.lock_table_arn
}

# --- The service repo (pure GitHub, no AWS) ---
module "test_service" {
  source = "./modules/service-repo"

  repo_name        = "aws-service-test-delete-me"
  repo_description = "Test service repo — safe to delete"
  gh_org_name      = "infrahouse"
  github_app_slug  = "infrahouse-github-terraform"
  template_repo    = "terraform-root-template"
  state_bucket     = module.test_service_state.bucket_name

  environments = {
    sandbox = {
      region                 = "us-west-1"
      admin_role_arn         = module.test_service_gha_sandbox.admin_role_arn
      github_role_arn        = module.test_service_gha_sandbox.github_role_arn
      state_manager_role_arn = module.test_service_gha_sandbox.state_manager_role_arn
      deploy_order           = 0
    }
  }

  pipeline_guardians       = "admins"
  infrastructure_approvers = "developers"
  release_managers         = "admins"

  committers = {
    developers = github_team.dev.id
  }
  admins = {
    admins = github_team.admins.id
  }
}
