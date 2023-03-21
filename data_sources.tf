data "external" "env" {
  program = ["bash", "${path.module}/env.sh"]
}

data "aws_ssm_parameter" "gh_secrets_namespace" {
  name = "gh_secrets_namespace"
}

data "aws_secretsmanager_secrets" "gh_secrets" {
  filter {
    name   = "name"
    values = []
  }
}
