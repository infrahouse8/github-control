locals {
  infrahouse_8_repos = {
    "github-control" : {
      description   = "InfraHouse GitHub configuration"
      role          = "arn:aws:iam::990466748045:role/github-admin"
      template_repo = github_repository.terraform-template.name
    }
    "aws-control" : {
      description   = "InfraHouse Basic AWS configuration"
      template_repo = github_repository.terraform-template.name
    }
    "aws-s3-control" : {
      description   = "InfraHouse Terraform State Buckets"
      role          = "arn:aws:iam::990466748045:role/s3-admin"
      template_repo = github_repository.terraform-template.name
    }
  }
}

module "ih_8_repos" {
  source           = "./modules/local-repo"
  for_each         = local.infrahouse_8_repos
  repo_name        = each.key
  repo_description = each.value["description"]
  role             = contains(keys(each.value), "role") ? each.value["role"] : null
  template_repo    = each.value["template_repo"]
  collaborators = [
    "akuzminsky"
  ]

  providers = {
    github = github.infrahouse8
  }
}


resource "github_repository" "terraform-template" {
  provider = github.infrahouse8
  name     = "terraform-template"
  description = join(
    " ",
    [
      "Template repository for a Terraform project.",
      "This repository is not supposed to become a cookiecutter.",
      "If you need one - check out https://github.com/infrahouse/cookiecutter-github-control .",
      "This repository will be used as a template to instantiate a new empty Terraform repository."
    ]
  )
  is_template = true
}
