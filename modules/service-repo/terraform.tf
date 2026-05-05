terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.7, >= 6.7.3"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}
