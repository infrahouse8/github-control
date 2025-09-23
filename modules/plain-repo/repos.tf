resource "github_repository" "repo" {
  name                   = var.repo_name
  description            = var.repo_description
  has_issues             = true
  visibility             = var.public_repo ? "public" : "private"
  vulnerability_alerts   = var.public_repo
  delete_branch_on_merge = true
  allow_auto_merge       = var.allow_auto_merge

}

resource "github_team_repository" "dev" {
  repository = github_repository.repo.name
  team_id    = var.team_id
  permission = "push"
}

resource "github_team_repository" "admin" {
  repository = github_repository.repo.name
  team_id    = var.admin_team_id
  permission = "admin"
}

resource "github_actions_secret" "secret" {
  for_each        = var.secrets
  repository      = github_repository.repo.name
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_branch_default" "main" {
  branch     = "main"
  repository = github_repository.repo.name
}
