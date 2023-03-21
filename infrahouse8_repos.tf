locals {
  infrahouse_8_repos = {
    github-control = {
      description       = "InfraHouse GitHub configuration"
      tf_admin_username = "tf_github"
      secrets = {
        AWS_ROLE = "arn:aws:iam::${local.aws_account_id}:role/github-admin"
      }
    }
    aws-control = {
      description       = "InfraHouse Basic AWS configuration"
      template_repo     = github_repository.terraform-template.name
      tf_admin_username = "tf_aws"
      secrets = {
      }
    }
    aws-s3-control = {
      description       = "InfraHouse Terraform State Buckets"
      template_repo     = github_repository.terraform-template.name
      tf_admin_username = "tf_s3"
      secrets = {
        AWS_ROLE = "arn:aws:iam::${local.aws_account_id}:role/s3-admin"
      }
    }
  }
}

module "aws_creds_infrahouse8" {
  source      = "./modules/aws_creds"
  for_each    = local.infrahouse_8_repos
  secret_name = join("/", [local.s_prefix, each.value["tf_admin_username"]])
}

module "ih_8_repos" {
  source           = "./modules/local-repo"
  for_each         = local.infrahouse_8_repos
  repo_name        = each.key
  repo_description = each.value["description"]
  template_repo    = contains(keys(each.value), "template_repo") ? each.value["template_repo"] : null
  secrets = merge(contains(keys(each.value), "secrets") ? each.value["secrets"] : {},
    {
      AWS_DEFAULT_REGION    = "us-west-1"
      AWS_ACCESS_KEY_ID     = module.aws_creds_infrahouse8[each.key].aws_access_key_id
      AWS_SECRET_ACCESS_KEY = module.aws_creds_infrahouse8[each.key].aws_secret_access_key
      GH_TOKEN              = data.external.env.result["GH_TOKEN"]
    }
  )
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
