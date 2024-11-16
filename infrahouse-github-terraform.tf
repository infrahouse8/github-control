data "aws_iam_role" "actions-runner-tester" {
  provider = aws.aws-303467602807-uw1
  name     = "actions-runner-tester"
}

module "infrahouse-github-terraform-pem" {
  providers = {
    aws = aws.aws-303467602807-uw1
  }
  source             = "registry.infrahouse.com/infrahouse/secret/aws"
  version            = "~> 0.6"
  secret_description = "infrahouse-github-terraform App private key (pem)"
  secret_name        = "infrahouse-github-terraform-app-key"
  writers = [
    tolist(data.aws_iam_roles.sso-admin.arns)[0]
  ]
}
