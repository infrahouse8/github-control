resource "github_actions_organization_variable" "infrahouse-backup-bucket" {
  variable_name = "INFRAHOUSE_BACKUP_BUCKET"
  visibility    = "private"
  value         = aws_s3_bucket.infrahouse-backup.bucket
}

resource "github_actions_organization_variable" "infrahouse-backup-role" {
  variable_name = "INFRAHOUSE_BACKUP_ROLE"
  visibility    = "private"
  value         = aws_iam_role.infrahouse-backup.arn
}
