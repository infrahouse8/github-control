locals {
  infrahouse_8_repos = {
    "github-control" : {
      description = "InfraHouse GitHub configuration"
      role        = "arn:aws:iam::990466748045:role/github-admin"
    }
    "aws-s3-control" : {
      description = "InfraHouse Terraform State Buckets"
    }
  }
}

module "ih_8_repos" {
  source           = "./modules/local-repo"
  for_each         = local.infrahouse_8_repos
  repo_name        = each.key
  repo_description = each.value["description"]
  role             = contains(keys(each.value), "role") ? each.value["role"] : null

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

}
