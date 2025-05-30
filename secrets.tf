resource "aws_secretsmanager_secret" "pypi_api_token" {
  provider                       = aws.aws-303467602807-uw1
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


resource "aws_secretsmanager_secret" "codacy_api_token" {
  provider                       = aws.aws-303467602807-uw1
  name                           = "${data.aws_ssm_parameter.gh_secrets_namespace.value}CODACY_PROJECT_TOKEN"
  description                    = "Token for Codacy Coverage"
  force_overwrite_replica_secret = true
  recovery_window_in_days        = 0
}


module "actions-runner-pem" {
  providers = {
    aws = aws.aws-303467602807-uw1
  }
  source             = "registry.infrahouse.com/infrahouse/secret/aws"
  version            = "1.0.1"
  environment        = local.environment
  secret_description = "A copy of infrahouse-github-terraform App private key (pem) for actions-runner tests"
  secret_name_prefix = "action-runner-pem-"
  secret_value       = module.infrahouse-github-terraform-pem.secret_value
  readers = [
    data.aws_iam_role.actions-runner-tester.arn,
    tolist(data.aws_iam_roles.sso-admin.arns)[0],
    data.aws_iam_role.ih-tf-aws-control-303467602807-admin.arn,
    "arn:aws:iam::303467602807:role/infrahouse-registration*"
  ]
}

module "actions-runner-pem-493370826424-uw1" {
  providers = {
    aws = aws.aws-493370826424-uw1
  }
  source             = "registry.infrahouse.com/infrahouse/secret/aws"
  version            = "1.0.1"
  environment        = local.environment
  secret_description = "A copy of infrahouse-github-terraform App private key (pem) for actions-runner tests"
  secret_name_prefix = "action-runner-pem-"
  secret_value       = module.infrahouse-github-terraform-pem.secret_value
}
