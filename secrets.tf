resource "aws_secretsmanager_secret" "pypi_api_token" {
  provider                       = aws.uw1
  name                           = "PYPI_API_TOKEN"
  description                    = <<-EOT
Token for "GitHub Publishing"
Permissions: Upload packages
Scope: Entire account (all projects)
EOT
  force_overwrite_replica_secret = true
  recovery_window_in_days        = 0
}


data "aws_secretsmanager_secret_version" "PYPI_API_TOKEN" {
  secret_id = aws_secretsmanager_secret.pypi_api_token.id
}

resource "github_actions_secret" "infrahouse-toolkit-PYPI_API_TOKEN" {
  repository       = "infrahouse-toolkit"
  secret_name      = "PYPI_API_TOKEN"
  plaintext_value  = data.aws_secretsmanager_secret_version.PYPI_API_TOKEN.secret_string
}
