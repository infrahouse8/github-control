data "github_app" "terraform" {
  slug = var.github_app_slug
}

data "github_team" "release_managers" {
  slug = var.release_managers
}

resource "github_repository" "this" {
  name                        = var.repo_name
  description                 = var.repo_description
  has_downloads               = true
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  vulnerability_alerts        = var.archived ? false : true
  allow_update_branch         = true
  allow_merge_commit          = true
  allow_rebase_merge          = true
  allow_squash_merge          = true
  delete_branch_on_merge      = true
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"
  merge_commit_title          = "MERGE_MESSAGE"
  merge_commit_message        = "PR_TITLE"
  archived                    = var.archived
  visibility                  = var.repo_private ? "private" : "public"
  web_commit_signoff_required = false

  template {
    owner      = var.gh_org_name
    repository = var.template_repo
  }
}

resource "github_branch_default" "main" {
  branch     = local.default_branch
  repository = github_repository.this.name
}

resource "github_team_repository" "committers" {
  for_each   = var.committers
  repository = github_repository.this.name
  team_id    = each.value
  permission = "push"
}

resource "github_team_repository" "admins" {
  for_each   = var.admins
  repository = github_repository.this.name
  team_id    = each.value
  permission = "admin"
}

resource "github_actions_secret" "secret" {
  for_each        = var.secrets
  repository      = github_repository.this.name
  secret_name     = each.key
  plaintext_value = each.value
}
