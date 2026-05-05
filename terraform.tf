terraform {
  backend "s3" {
    bucket = "infrahouse-github-control-state"
    key    = "terraform.tfstate"
    region = "us-west-1"
    assume_role = {
      role_arn = "arn:aws:iam::289256138624:role/ih-tf-github-control-state-manager"
    }
    dynamodb_table = "infrahouse-github-control-state-central-lamprey"
    encrypt        = true
  }

  required_providers {
    github = {
      source = "integrations/github"
      # 6.7.3 causes "Root object was present, but now absent"
      # on github_actions_secret due to destroy_on_drift bug.
      # https://github.com/integrations/terraform-provider-github/issues/2387
      version = "~> 6.7, != 6.7.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.43"
    }
  }
}
