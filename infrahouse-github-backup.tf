module "infrahouse-github-backup" {
  providers = {
    aws = aws.aws-303467602807-uw1
  }
  source  = "registry.infrahouse.com/infrahouse/github-backup-configuration/aws"
  version = "0.1.0"
}
