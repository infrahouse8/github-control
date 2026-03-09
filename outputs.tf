output "github-control-lock-table" {
  description = "A DynamoDB table name for state lock in github-control."
  value       = nonsensitive(data.aws_ssm_parameter.github_control_lock_table.value)
}

output "github-control-state-bucket" {
  description = "An S3 bucket for github-control state."
  value       = nonsensitive(data.aws_ssm_parameter.github_control_state_bucket.value)
}

output "github-control-roles" {
  description = "Terraform CI/CD roles used in github-control."
  value = {
    "github" : nonsensitive(data.aws_ssm_parameter.github_control_github_role.value)
    "state-manager" : nonsensitive(data.aws_ssm_parameter.github_control_state_manager_role.value)
    "admin" : nonsensitive(data.aws_ssm_parameter.github_control_admin_role.value)
  }
}
