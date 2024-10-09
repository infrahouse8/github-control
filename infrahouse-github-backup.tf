module "infrahouse-github-backup" {
  providers = {
    aws = aws.aws-303467602807-uw1
  }
  source  = "infrahouse/github-backup-configuration/aws"
  version = "0.1.0"
}
