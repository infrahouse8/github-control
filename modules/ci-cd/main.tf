module "gha-admin" {
  source  = "infrahouse/gha-admin/aws"
  version = "~> 3.0"
  providers = {
    aws          = aws
    aws.cicd     = aws.cicd
    aws.tfstates = aws.tf-states
  }
  gh_org_name               = var.gh_org
  repo_name                 = var.gh_repo
  state_bucket              = var.state_bucket
  terraform_locks_table_arn = module.state-bucket.lock_table_arn

  admin_policy_name  = var.admin_policy_name
  admin_allowed_arns = var.admin_allowed_arns
}

module "state-bucket" {
  source  = "infrahouse/state-bucket/aws"
  version = "~> 2.0"
  providers = {
    aws = aws.tf-states
  }
  bucket = var.state_bucket
  tags = {
    "used_by" : "${var.gh_org}/${var.gh_repo}"
  }
}
