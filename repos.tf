locals {
  repos = {
    "infrahouse-toolkit" : {
      description = "InfraHouse Toolkit"
      team_id     = github_team.dev.id
      type        = "python_app"
      secrets = {
        PYPI_API_TOKEN = data.aws_secretsmanager_secret_version.pypi_api_token.secret_string
      }
    }
    "infrahouse-website-infra" : {
      description       = "InfraHouse Website Infrastructure"
      team_id           = github_team.dev.id
      type              = "terraform_aws"
      tf_admin_username = "tf_aws"
      secrets = {
        AWS_ROLE = "arn:aws:iam::${local.aws_account_id}:role/aws-admin"
      }

    }
    "infrahouse-aws-control" : {
      description       = "InfraHouse AWS Infrastructure"
      team_id           = github_team.dev.id
      type              = "terraform_aws"
      tf_admin_username = "tf_aws"
      secrets = {
        AWS_ROLE = "arn:aws:iam::${local.aws_account_id}:role/aws-admin"
      }

    }
    "cookiecutter-github-control" : {
      description = "Template for a GitHub Control repository"
      team_id     = github_team.dev.id
      type        = "other"
    }
  }
}

module "repos" {
  source           = "./modules/plain-repo"
  for_each         = local.repos
  repo_name        = each.key
  repo_description = each.value["description"]
  team_id          = each.value["team_id"]
  secrets = merge(
    contains(keys(each.value), "secrets") ? each.value["secrets"] : {},
    merge(
      {
        GH_TOKEN = data.external.env.result["GH_TOKEN"]
      },
      contains(keys(each.value), "tf_admin_username") ?
      {
        AWS_DEFAULT_REGION    = local.aws_default_region
        AWS_ACCESS_KEY_ID     = module.aws_creds[each.key].aws_access_key_id
        AWS_SECRET_ACCESS_KEY = module.aws_creds[each.key].aws_secret_access_key

      } :
      {}
    )
  )

}
