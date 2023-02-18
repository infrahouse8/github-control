resource "github_repository" "repo" {
  name        = var.repo_name
  description = var.repo_description
  has_issues  = true
  visibility  = "public"
}

resource "github_team_repository" "dev" {
  repository = github_repository.repo.name
  team_id    = var.team_id
  permission = "push"
}
