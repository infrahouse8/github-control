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
      IH_GH_TF_APP_KEY = module.infrahouse-github-terraform-pem.secret_value
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

resource "github_actions_variable" "role_admin" {
  provider      = github.infrahouse8
  repository    = module.ih_8_repos["github-control"].repo_name
  value         = data.aws_ssm_parameter.github_control_admin_role.value
  variable_name = "role_admin"
}

resource "github_actions_variable" "role_github" {
  provider      = github.infrahouse8
  repository    = module.ih_8_repos["github-control"].repo_name
  value         = data.aws_ssm_parameter.github_control_github_role.value
  variable_name = "role_github"
}

resource "github_actions_variable" "role_state_manager" {
  provider      = github.infrahouse8
  repository    = module.ih_8_repos["github-control"].repo_name
  value         = data.aws_ssm_parameter.github_control_state_manager_role.value
  variable_name = "role_state_manager"
}

resource "github_actions_variable" "state_bucket" {
  provider      = github.infrahouse8
  repository    = module.ih_8_repos["github-control"].repo_name
  value         = data.aws_ssm_parameter.github_control_state_bucket.value
  variable_name = "state_bucket"
}

resource "github_actions_variable" "dynamodb_lock_table_name" {
  provider      = github.infrahouse8
  repository    = module.ih_8_repos["github-control"].repo_name
  value         = data.aws_ssm_parameter.github_control_lock_table.value
  variable_name = "dynamodb_lock_table_name"
}
