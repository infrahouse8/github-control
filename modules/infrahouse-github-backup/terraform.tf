terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.27"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.20"
    }
  }
}
