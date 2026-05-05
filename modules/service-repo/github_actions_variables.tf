resource "github_actions_variable" "role_github" {
  repository    = github_repository.this.name
  variable_name = "ROLE_GITHUB"
  value = jsonencode({
    for env, config in var.environments :
    env => config.github_role_arn
  })
}

resource "github_actions_variable" "role_admin" {
  repository    = github_repository.this.name
  variable_name = "ROLE_ADMIN"
  value = jsonencode({
    for env, config in var.environments :
    env => config.admin_role_arn
  })
}

resource "github_actions_variable" "role_state_manager" {
  repository    = github_repository.this.name
  variable_name = "ROLE_STATE_MANAGER"
  value = jsonencode({
    for env, config in var.environments :
    env => config.state_manager_role_arn
  })
}

resource "github_actions_variable" "state_bucket" {
  repository    = github_repository.this.name
  variable_name = "STATE_BUCKET"
  value         = var.state_bucket
}

resource "github_actions_variable" "aws_default_region" {
  repository    = github_repository.this.name
  variable_name = "AWS_DEFAULT_REGION"
  value = jsonencode({
    for env, config in var.environments :
    env => config.region
  })
}
