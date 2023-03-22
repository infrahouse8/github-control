data "external" "env" {
  program = ["bash", "${path.module}/env.sh"]
}

data "aws_ssm_parameter" "gh_secrets_namespace" {
  name = "gh_secrets_namespace"
}

data "aws_secretsmanager_secrets" "gh_secrets" {
  filter {
    name   = "name"
    values = []
  }
}

module "aws_creds" {
  source = "./modules/aws_creds"
  for_each = {
    for repo_name, repo_config in merge(local.infrahouse_8_repos, local.repos) : repo_name => repo_config
    if contains(keys(repo_config), "tf_admin_username")
  }
  secret_name = join("/", [local.s_prefix, each.value["tf_admin_username"]])
}

data "aws_secretsmanager_secret_version" "pypi_api_token" {
  secret_id = aws_secretsmanager_secret.pypi_api_token.id
}
