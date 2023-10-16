output "github-control-lock-table" {
  description = "A DynamoDB table name for state lock in github-control."
  value       = module.infrahouse8-github-control.lock_table_name
}

output "github-control-state-bucket" {
  description = "An S3 bucket for github-control state."
  value       = module.infrahouse8-github-control.bucket_name
}

output "github-control-roles" {
  description = "Terraform CI/CD roles used in github-control."
  value = {
    "github" : module.infrahouse8-github-control.github-role
    "state-manager" : module.infrahouse8-github-control.state-manager-role
    "admin" : module.infrahouse8-github-control.admin-role
  }
}
