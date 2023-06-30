terraform {
  backend "s3" {
    bucket   = "infrahouse-github-state"
    key      = "github.state"
    region   = "us-west-1"
    role_arn = "arn:aws:iam::289256138624:role/ih-tf-terraform-control"
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.27"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67"
    }
  }
}
