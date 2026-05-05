resource "github_repository_file" "terraform_tf" {
  for_each            = var.environments
  repository          = github_repository.this.name
  file                = "environments/${each.key}/terraform.tf"
  overwrite_on_create = true
  content = templatefile("${path.module}/templates/terraform.tf.tftpl", {
    state_bucket             = var.state_bucket
    environment              = each.key
    region                   = each.value.region
    state_manager_role_arn   = each.value.state_manager_role_arn
    aws_provider_constraint  = var.aws_provider_constraint
    extra_required_providers = var.extra_required_providers
  })
  commit_message = "Add terraform.tf for ${each.key} environment"
  branch         = local.default_branch
}

resource "github_repository_file" "terraform_tfvars" {
  for_each            = var.environments
  repository          = github_repository.this.name
  file                = "environments/${each.key}/terraform.tfvars"
  overwrite_on_create = true
  content = templatefile("${path.module}/templates/terraform.tfvars.tftpl", {
    state_manager_role_arn = each.value.state_manager_role_arn
    admin_role_arn         = each.value.admin_role_arn
    github_role_arn        = each.value.github_role_arn
    gh_org_name            = var.gh_org_name
    repo_name              = var.repo_name
    region                 = each.value.region
  })
  commit_message = "Add terraform.tfvars for ${each.key} environment"
  branch         = local.default_branch
  lifecycle {
    ignore_changes = [content]
  }
}

resource "github_repository_file" "releases_auto_tfvars" {
  for_each            = var.environments
  repository          = github_repository.this.name
  file                = "environments/${each.key}/releases.auto.tfvars"
  overwrite_on_create = true
  content             = file("${path.module}/templates/releases.auto.tfvars.tftpl")
  commit_message      = "Add releases.auto.tfvars for ${each.key} environment"
  branch              = local.default_branch
  lifecycle {
    ignore_changes = [content]
  }
}
