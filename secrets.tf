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
