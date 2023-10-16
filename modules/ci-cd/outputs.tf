output "github-role" {
  value = module.gha-admin.github_role_arn
}

output "admin-role" {
  value = module.gha-admin.admin_role_arn
}

output "state-manager-role" {
  value = module.gha-admin.state_manager_role_arn
}

output "bucket_name" {
  value = module.state-bucket.bucket_name
}

output "lock_table_name" {
  value = module.state-bucket.lock_table_name
}

output "bucket_arn" {
  value = module.state-bucket.bucket_arn
}

output "lock_table_arn" {
  value = module.state-bucket.lock_table_arn
}
