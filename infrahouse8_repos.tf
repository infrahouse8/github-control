locals {
  infrahouse_8_repos = {
    github-control = {
      description       = "InfraHouse GitHub configuration"
      tf_admin_username = "tf_github"
      secrets = {
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
      GH_TOKEN = data.external.env.result["GH_TOKEN"]
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


module "infrahouse8-github-control" {
  source  = "infrahouse/ci-cd/aws"
  version = "~> 1.0"
  providers = {
    aws          = aws.aws-303467602807-uw1
    aws.cicd     = aws.aws-303467602807-uw1
    aws.tfstates = aws.aws-289256138624-uw1
  }
  gh_org       = "infrahouse8"
  gh_repo      = "github-control"
  state_bucket = "infrahouse-github-control-state"
  allowed_arns = [
    "arn:aws:iam::289256138624:role/ih-tf-terraform-control"
  ]
  trusted_arns = [
    local.me_arn
  ]
}


resource "github_actions_variable" "role-admin" {
  repository    = module.ih_8_repos["github-control"].repo_name
  value         = module.infrahouse8-github-control.admin-role
  variable_name = "role-admin"
}

resource "github_actions_variable" "role-github" {
  repository    = module.ih_8_repos["github-control"].repo_name
  value         = module.infrahouse8-github-control.github-role
  variable_name = "role-github"
}

resource "github_actions_variable" "role-state-manager" {
  repository    = module.ih_8_repos["github-control"].repo_name
  value         = module.infrahouse8-github-control.state-manager-role
  variable_name = "role-state-manager"
}

resource "github_actions_variable" "state-bucket" {
  repository    = module.ih_8_repos["github-control"].repo_name
  value         = module.infrahouse8-github-control.bucket_name
  variable_name = "state-bucket"
}

resource "github_actions_variable" "dynamodb-lock-table-name" {
  repository    = module.ih_8_repos["github-control"].repo_name
  value         = module.infrahouse8-github-control.lock_table_name
  variable_name = "dynamodb-lock-table-name"
}
