module "gha-admin" {
  source  = "infrahouse/gha-admin/aws"
  version = "~> 3.0"
  providers = {
    aws          = aws
    aws.cicd     = aws.cicd
    aws.tfstates = aws.tf-states
  }
  # insert the 4 required variables here
  gh_org_name               = var.gh_org
  repo_name                 = var.gh_repo
  state_bucket              = var.state_bucket
  terraform_locks_table_arn = module.state-bucket.lock_table_arn
}

module "state-bucket" {
  source  = "infrahouse/state-bucket/aws"
  version = "~> 2.0"
  bucket  = var.state_bucket
  providers = {
    aws = aws.tf-states
  }
}
