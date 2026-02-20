data "aws_ssm_parameter" "gh_secrets_namespace" {
  provider = aws.aws-303467602807-uw1
  name     = "gh_secrets_namespace"
}

data "aws_ssm_parameter" "github_control_admin_role" {
  provider = aws.aws-303467602807-uw1
  name     = "/terraform/github-control/ci-cd/admin_role_arn"
}

data "aws_ssm_parameter" "github_control_github_role" {
  provider = aws.aws-303467602807-uw1
  name     = "/terraform/github-control/ci-cd/github_role_arn"
}

data "aws_ssm_parameter" "github_control_state_manager_role" {
  provider = aws.aws-303467602807-uw1
  name     = "/terraform/github-control/backend/state_manager_role_arn"
}

data "aws_ssm_parameter" "github_control_state_bucket" {
  provider = aws.aws-303467602807-uw1
  name     = "/terraform/github-control/backend/state_bucket"
}

data "aws_ssm_parameter" "github_control_lock_table" {
  provider = aws.aws-303467602807-uw1
  name     = "/terraform/github-control/backend/lock_table"
}


data "aws_secretsmanager_secrets" "gh_secrets" {
  provider = aws.aws-303467602807-uw1
  filter {
    name   = "name"
    values = []
  }
}


data "aws_secretsmanager_secret_version" "pypi_api_token" {
  provider  = aws.aws-303467602807-uw1
  secret_id = aws_secretsmanager_secret.pypi_api_token.id
}

data "aws_secretsmanager_secret_version" "codacy_api_token" {
  provider  = aws.aws-303467602807-uw1
  secret_id = aws_secretsmanager_secret.codacy_api_token.id
}

data "aws_iam_roles" "sso-admin" {
  provider    = aws.aws-303467602807-uw1
  name_regex  = "AWSReservedSSO_AWSAdministratorAccess_.*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}

data "aws_iam_role" "ih-tf-aws-control-303467602807-admin" {
  provider = aws.aws-303467602807-uw1
  name     = "ih-tf-aws-control-303467602807-admin"
}
