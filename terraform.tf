terraform {
  backend "s3" {
    bucket = "infrahouse-github-state"
    key    = "github.state"
  }
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}
