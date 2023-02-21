locals {
  repos = {
    "infrahouse-toolkit" : {
      description = "(UPDATE): InfraHouse Toolkit"
      team_id     = github_team.dev.id
      type        = "python_app"
    }
    "demo-repo" : {
      description = "This is a demo repo"
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
