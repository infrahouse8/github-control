output "aws_access_key_id" {
  value = data.aws_secretsmanager_secret_version.aws_access_key_id.secret_string
}

output "aws_secret_access_key" {
  value = data.aws_secretsmanager_secret_version.aws_secret_access_key.secret_string
}
