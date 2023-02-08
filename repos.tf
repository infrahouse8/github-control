locals {
  repos = {
    "infrahouse-toolkit": {
      description = "InfraHouse Toolkit"
      team_id = github_team.dev.id
    }
  }
}

module "repos" {
  source = "./modules/plain-repo"
  for_each = local.repos
  repo_name = each.key
  repo_description = each.value["description"]
  team_id = each.value["team_id"]
}

resource "github_repository" "cookiecutter-github-control" {
  name        = "cookiecutter-github-control"
  description = "Template for a GitHub Control repository"

  visibility = "public"
}

resource "github_team_repository" "dev" {
  repository = github_repository.cookiecutter-github-control.name
  team_id    = github_team.dev.id
  permission = "push"
}
