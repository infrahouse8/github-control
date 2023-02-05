resource "github_membership" "infrahouse" {
  for_each = toset(var.developers)
  username = each.key
}
