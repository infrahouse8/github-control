resource "github_repository" "github-control" {
  provider             = github.infrahouse8
  name                 = "github-control"
  description          = "InfraHouse GitHub configuration"
  has_downloads        = false
  has_issues           = true
  has_projects         = false
  has_wiki             = false
  vulnerability_alerts = true
}
