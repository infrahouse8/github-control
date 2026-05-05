locals {
  aws_default_region = "us-west-1"
  environment        = "production"

  gh_org_name = "infrahouse"

  team_members = {
    "akuzminsky" : [
      github_team.dev.name,
      github_team.admins.name
    ],
    "naumenko" : [
      github_team.dev.name,
    ],
  }
}
