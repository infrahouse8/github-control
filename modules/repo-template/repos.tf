resource "github_repository" "repo" {
  name        = var.repo_name
  description = var.repo_description
  has_issues  = true
  visibility  = "public"
  is_template = true
}

resource "github_team_repository" "dev" {
  count      = var.team_id != null ? 1 : 0
  repository = github_repository.repo.name
  team_id    = var.team_id
  permission = "push"
}
