terraform {
  backend "s3" {
    bucket         = "infrahouse-github-control-state"
    key            = "terraform.tfstate"
    region         = "us-west-1"
    role_arn       = "arn:aws:iam::289256138624:role/ih-tf-github-control-state-manager"
    dynamodb_table = "infrahouse-github-control-state-polished-lioness"
    encrypt        = true
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.27"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.11"
    }
  }
}
