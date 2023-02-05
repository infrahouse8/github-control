resource "github_team" "dev" {
  name        = "developers"
  description = "Development Team"
  privacy     = "closed"
}

resource "github_team_members" "dev" {
  team_id = github_team.dev.id
  dynamic "members" {
    for_each = toset(var.developers)
    content {
      username = members.key
    }
  }
}
