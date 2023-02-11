locals {
  repos = {
    "infrahouse-toolkit" : {
      description = "InfraHouse Toolkit"
      team_id     = github_team.dev.id
      type        = "python_app"
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
}
