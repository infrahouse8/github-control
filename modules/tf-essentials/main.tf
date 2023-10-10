module "gha-admin" {
  source  = "infrahouse/gha-admin/aws"
  version = "~> 2.0"
  # insert the 4 required variables here
  gh_org_name               = ""
  repo_name                 = ""
  state_bucket              = ""
  terraform_locks_table_arn = ""
}
