output "aws_access_key_id" {
  value = jsondecode(data.aws_secretsmanager_secret_version.aws_key.secret_string)["aws_access_key_id"]
}

output "aws_secret_access_key" {
  value = jsondecode(data.aws_secretsmanager_secret_version.aws_key.secret_string)["aws_secret_access_key"]
}
