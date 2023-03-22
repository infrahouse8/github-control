resource "aws_secretsmanager_secret" "pypi_api_token" {
  provider                       = aws.uw1
  name                           = "${data.aws_ssm_parameter.gh_secrets_namespace.value}PYPI_API_TOKEN"
  description                    = <<-EOT
Token for "GitHub Publishing"
Permissions: Upload packages
Scope: Entire account (all projects)
Created in https://pypi.org/manage/account/
EOT
  force_overwrite_replica_secret = true
  recovery_window_in_days        = 0
}
