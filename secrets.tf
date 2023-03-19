resource "aws_secretsmanager_secret" "pypi_api_token" {
  provider                       = aws.uw1
  name                           = "_github_control__PYPI_API_TOKEN"
  description                    = <<-EOT
Token for "GitHub Publishing"
Permissions: Upload packages
Scope: Entire account (all projects)
Created in https://pypi.org/manage/account/
EOT
  force_overwrite_replica_secret = true
  recovery_window_in_days        = 0
}


data "aws_secretsmanager_secret_version" "pypi_api_token" {
  secret_id = aws_secretsmanager_secret.pypi_api_token.id
}


resource "github_actions_secret" "pypi_api_token" {
  for_each = {
    for k in keys(local.repos) :
    k => local.repos[k]
    if local.repos[k]["type"] == "python_app"
  }
  repository      = each.key
  secret_name     = "PYPI_API_TOKEN" ## Note: not the same name as in aws_secretsmanager_secret.pypi_api_token
  plaintext_value = data.aws_secretsmanager_secret_version.pypi_api_token.secret_string
}

locals {
  secrets_namespace = "_github_control__"
  s_prefix          = "${local.secrets_namespace}tf_admin"
}


module "aws_creds" {
  source = "./modules/aws_creds"
  for_each = {
    for k in keys(local.repos) :
    k => local.repos[k]
    if local.repos[k]["type"] == "terraform_aws"
  }
  secret_name = join("/", [local.s_prefix, each.value["tf_admin_username"]])
}


resource "github_actions_secret" "aws_access_key_id" {
  for_each = {
    for k in keys(local.repos) :
    k => local.repos[k]
    if local.repos[k]["type"] == "terraform_aws"
  }
  repository      = each.key
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = module.aws_creds[each.key].aws_access_key_id
}

resource "github_actions_secret" "aws_secret_access_key" {
  for_each = {
    for k in keys(local.repos) :
    k => local.repos[k]
    if local.repos[k]["type"] == "terraform_aws"
  }
  repository      = each.key
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = module.aws_creds[each.key].aws_secret_access_key
}
