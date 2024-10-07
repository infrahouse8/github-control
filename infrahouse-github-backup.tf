module "infrahouse-github-backup" {
  providers = {
    aws = aws.aws-303467602807-uw1
  }
  source = "./modules/infrahouse-github-backup"
}
