data "aws_secretsmanager_secret" "aws_key" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "aws_key" {
  secret_id = data.aws_secretsmanager_secret.aws_key.id
}
