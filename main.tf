resource "github_organization_settings" "infrahouse" {
  billing_email = "billing@infrahouse.com"
  company = "InfraHouse Inc."
  blog = "https://infrahouse.com"
  email = "github@infrahouse.com"
  location = "San Francisco, California"
  name = "InfraHouse"
  description = "Cloud infrastructure professional services."
  has_organization_projects = true
  has_repository_projects = true
  default_repository_permission = "read"
  members_can_create_repositories = true
  members_can_create_public_repositories = true
  members_can_create_private_repositories = true
  members_can_create_internal_repositories = true
  members_can_create_pages = true
  members_can_create_public_pages = true
  members_can_create_private_pages = true
  members_can_fork_private_repositories = true
  web_commit_signoff_required = true
  advanced_security_enabled_for_new_repositories = false
  dependabot_alerts_enabled_for_new_repositories=  false
  dependabot_security_updates_enabled_for_new_repositories = false
  dependency_graph_enabled_for_new_repositories = false
  secret_scanning_enabled_for_new_repositories = false
  secret_scanning_push_protection_enabled_for_new_repositories = false
}
