locals {
  aws_account_id     = "990466748045"
  aws_default_region = "us-west-1"

  s_prefix    = "${data.aws_ssm_parameter.gh_secrets_namespace.value}tf_admin"
  me_arn      = "arn:aws:iam::990466748045:user/aleks"
  environment = "production"
  team_members = {
    "akuzminsky" : [
      github_team.dev.name,
      github_team.admins.name
    ],
    "xOtanix" : [
      github_team.dev.name,
    ],
    "naumenko" : [
      github_team.dev.name,
    ],
  }
}
