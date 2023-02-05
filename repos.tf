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
