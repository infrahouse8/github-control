resource "github_repository_environment" "ci" {
  for_each    = var.environments
  environment = "continuous-integration-${each.key}"
  repository  = github_repository.this.name
}

resource "github_repository_environment" "cd" {
  for_each    = var.environments
  environment = "live-${each.key}"
  repository  = github_repository.this.name

  dynamic "reviewers" {
    for_each = each.value.deploy_order > 0 ? [1] : []
    content {
      teams = [data.github_team.release_managers.id]
    }
  }
}
