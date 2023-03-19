data "aws_secretsmanager_secret" "aws_access_key_id" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "aws_access_key_id" {
  secret_id = data.aws_secretsmanager_secret.aws_access_key_id.id
}


data "aws_secretsmanager_secret" "aws_secret_access_key" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "aws_secret_access_key" {
  secret_id = data.aws_secretsmanager_secret.aws_secret_access_key.id
}
