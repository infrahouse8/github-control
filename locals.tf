locals {
  aws_account_id     = "990466748045"
  aws_default_region = "us-west-1"

  s_prefix = "${data.aws_ssm_parameter.gh_secrets_namespace.value}tf_admin"

}
