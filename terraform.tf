terraform {
  backend "s3" {
    bucket   = "infrahouse-github-state"
    key      = "github.state"
    region   = "us-west-1"
    role_arn = "arn:aws:iam::990466748045:role/github-admin"
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.27"
    }
  }
}
