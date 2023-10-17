module "gha-admin" {
  source  = "infrahouse/gha-admin/aws"
  version = "~> 3.2"
  providers = {
    aws          = aws
    aws.cicd     = aws.cicd
    aws.tfstates = aws.tfstates
  }
  gh_org_name               = var.gh_org
  repo_name                 = var.gh_repo
  state_bucket              = module.state-bucket.bucket_name
  terraform_locks_table_arn = module.state-bucket.lock_table_arn

  admin_policy_name = var.admin_policy_name
  trusted_arns      = var.trusted_arns
  allowed_arns      = var.allowed_arns
}

module "state-bucket" {
  source  = "infrahouse/state-bucket/aws"
  version = "~> 2.0"
  providers = {
    aws = aws.tfstates
  }
  bucket = var.state_bucket
  tags = {
    "used_by" : "${var.gh_org}/${var.gh_repo}"
  }
}
