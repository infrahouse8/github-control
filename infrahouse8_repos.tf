locals {
  infrahouse_8_repos = {
    github-control = {
      description       = "InfraHouse GitHub configuration"
      tf_admin_username = "tf_github"
      secrets = {
        AWS_ROLE = "arn:aws:iam::${local.aws_account_id}:role/github-admin"
      }
    }
    aws-s3-control = {
      description       = "InfraHouse Terraform State Buckets"
      template_repo     = module.ih8_tf_template.name
      tf_admin_username = "tf_s3"
      secrets = {
        AWS_ROLE = "arn:aws:iam::${local.aws_account_id}:role/s3-admin"
      }
    }
  }
}


module "ih_8_repos" {
  source           = "./modules/local-repo"
  for_each         = local.infrahouse_8_repos
  repo_name        = each.key
  repo_description = each.value["description"]
  archived         = contains(keys(each.value), "archived") ? each.value["archived"] : null
  template_repo    = contains(keys(each.value), "template_repo") ? each.value["template_repo"] : null
  secrets = merge(contains(keys(each.value), "secrets") ? each.value["secrets"] : {},
    {
      AWS_DEFAULT_REGION = "us-west-1"
      GH_TOKEN           = data.external.env.result["GH_TOKEN"]
    }
  )
  collaborators = [
    "akuzminsky"
  ]

  providers = {
    github = github.infrahouse8
  }
}

module "ih8_tf_template" {
  source = "./modules/repo-template"
  repo_description = join(
    " ",
    [
      "Template repository for a Terraform project.",
      "This repository is not supposed to become a cookiecutter.",
      "If you need one - check out https://github.com/infrahouse/cookiecutter-github-control .",
      "This repository will be used as a template to instantiate a new empty Terraform repository."
    ]
  )
  repo_name = "terraform-template"
  providers = {
    github = github.infrahouse8
  }
}
