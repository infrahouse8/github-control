resource "github_repository" "github-control" {
  provider = github.infrahouse8

  name                 = "github-control"
  description          = "InfraHouse GitHub configuration"
  has_downloads        = false
  has_issues           = true
  has_projects         = false
  has_wiki             = false
  vulnerability_alerts = true
}

resource "github_branch_default" "github-control-main" {
  provider = github.infrahouse8

  branch     = "main"
  repository = github_repository.github-control.name
}

resource "github_branch_protection" "github-control-main" {
  provider = github.infrahouse8

  pattern       = github_branch_default.github-control-main.branch
  repository_id = github_branch_protection
}