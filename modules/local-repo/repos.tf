resource "github_repository" "repo" {
  name                 = var.repo_name
  description          = var.repo_description
  has_downloads        = false
  has_issues           = true
  has_projects         = false
  has_wiki             = false
  vulnerability_alerts = true
  template {
    owner      = "infrahouse8"
    repository = var.template_repo
  }
}

resource "github_branch_default" "main" {
  branch     = "main"
  repository = github_repository.repo.name
}

resource "github_branch_protection" "main" {
  pattern       = github_branch_default.main.branch
  repository_id = github_repository.repo.node_id

  required_status_checks {
    strict   = true
    contexts = var.checks
  }

  required_pull_request_reviews {
    required_approving_review_count = 0
  }
}

resource "github_actions_secret" "secret" {
  for_each        = var.secrets
  repository      = github_repository.repo.name
  secret_name     = each.key
  plaintext_value = each.value
}


resource "github_repository_collaborator" "collaborators" {
  for_each   = toset(var.collaborators)
  repository = github_repository.repo.name
  username   = each.key
}
