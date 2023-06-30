data "external" "env" {
  program = ["bash", "${path.module}/env.sh"]
}

data "aws_ssm_parameter" "gh_secrets_namespace" {
  provider = aws.aws-303467602807-uw1
  name     = "gh_secrets_namespace"
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
