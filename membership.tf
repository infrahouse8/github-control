resource "github_membership" "infrahouse" {
  for_each = toset(keys(local.team_members))
  username = each.key
}
