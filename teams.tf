resource "github_team" "dev" {
  name        = "developers"
  description = "Development Team"
  privacy     = "closed"
}

resource "github_team_members" "dev" {
  team_id = github_team.dev.id
  dynamic "members" {
    for_each = toset(
      [
        for username, teams in local.team_members : username
        if contains(teams, github_team.dev.name)
      ]
    )
    content {
      username = members.key
    }
  }
}

resource "github_team" "admins" {
  name        = "admins"
  description = "Admin Team"
  privacy     = "closed"
}

resource "github_team_members" "admins" {
  team_id = github_team.dev.id
  dynamic "members" {
    for_each = toset(
      [
        for username, teams in local.team_members : username
        if contains(teams, github_team.admins.name)
      ]
    )
    content {
      username = members.key
    }
  }
}
