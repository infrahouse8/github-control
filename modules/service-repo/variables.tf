variable "repo_name" {
  description = "Repository name (without the org prefix)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.repo_name))
    error_message = <<-EOT
      repo_name must be lowercase alphanumeric with hyphens, cannot start
      or end with a hyphen. Got: ${var.repo_name}
    EOT
  }
}

variable "repo_description" {
  description = "One-line repository description."
  type        = string
}

variable "gh_org_name" {
  description = "GitHub organization name."
  type        = string
}

variable "github_app_slug" {
  description = "Slug of the GitHub App used for branch protection bypass."
  type        = string
}

variable "environments" {
  description = <<-EOT
    Map of environment name to configuration. Each environment gets its own
    state key in the shared state bucket, injected backend configuration,
    and CI/CD workflow matrix entry.

    The map key is the environment name (e.g., "sandbox", "production",
    "staging"). It must be lowercase alphanumeric with underscores only
    (no hyphens) to comply with Puppet environment naming and Terraform
    workspace conventions.

    IAM role ARNs are created by the caller (typically via the published
    terraform-aws-gha-admin module) and passed in here. The module does
    not create IAM roles or state buckets.

    deploy_order controls the CD workflow sequence. Environments with the
    same order deploy in parallel; higher numbers wait for lower ones to
    finish (chained via needs:). Environments with deploy_order > 0 are
    gated by a GitHub environment protection rule — var.release_managers
    must approve before the deployment proceeds. Order 0 (default) deploys
    automatically after PR merge.
  EOT
  type = map(object({
    region                 = string
    admin_role_arn         = string
    github_role_arn        = string
    state_manager_role_arn = string
    deploy_order           = optional(number, 0)
  }))

  validation {
    condition = alltrue([
      for name, _ in var.environments :
      can(regex("^[a-z0-9_]+$", name))
    ])
    error_message = <<-EOT
      Environment names must contain only lowercase letters, numbers,
      and underscores (no hyphens).
    EOT
  }

  validation {
    condition = alltrue([
      for _, env in var.environments :
      can(regex("^arn:aws:iam::[0-9]{12}:role/", env.admin_role_arn))
    ])
    error_message = "admin_role_arn must be a valid IAM role ARN."
  }

  validation {
    condition = alltrue([
      for _, env in var.environments :
      can(regex("^arn:aws:iam::[0-9]{12}:role/", env.github_role_arn))
    ])
    error_message = "github_role_arn must be a valid IAM role ARN."
  }

  validation {
    condition = alltrue([
      for _, env in var.environments :
      can(regex("^arn:aws:iam::[0-9]{12}:role/", env.state_manager_role_arn))
    ])
    error_message = "state_manager_role_arn must be a valid IAM role ARN."
  }
}

variable "state_bucket" {
  description = <<-EOT
    Name of the S3 bucket used for Terraform state. A single bucket is shared
    across all environments; each environment uses a different key
    ({environment}/terraform.tfstate). Created by the caller.
  EOT
  type        = string
}

variable "repo_private" {
  description = <<-EOT
    If true, the repository is private.
    Rulesets and environments on private repos require a GitHub Team
    plan ($4/user/month).
  EOT
  type        = bool
  default     = true
}

variable "committers" {
  description = "Map of {team-name: team_id} with push permission."
  type        = map(string)
  default     = {}
}

variable "admins" {
  description = "Map of {team-name: team_id} with admin permission."
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Map of GitHub Actions secret name to value."
  type        = map(string)
  default     = {}
}

variable "checks" {
  description = <<-EOT
    Additional required status checks beyond the auto-generated
    per-environment "Terraform Plan {env}" checks.
  EOT
  type        = list(string)
  default     = []
}

variable "approvals_count" {
  description = "Number of PR approvals required."
  type        = number
  default     = 1
}

variable "aws_provider_constraint" {
  description = "Version constraint for the AWS provider in generated terraform.tf files."
  type        = string
  default     = "~> 6.0"
}

variable "extra_required_providers" {
  description = "Additional provider blocks to include in generated terraform.tf files."
  type = map(object({
    source  = string
    version = string
  }))
  default = {}
}

variable "pipeline_guardians" {
  description = <<-EOT
    GitHub team slug that must approve changes to .github/workflows/**.
    PCI-DSS separation of duties: pipeline changes require independent
    review from a security/platform function.
  EOT
  type        = string
}

variable "infrastructure_approvers" {
  description = <<-EOT
    GitHub team slug that must approve infrastructure changes (catch-all
    CODEOWNERS * entry, excluding release files).
  EOT
  type        = string
}

variable "release_managers" {
  description = <<-EOT
    GitHub team slug that must approve release changes — Docker image
    labels, feature flags, and application configuration in
    environments/{env}/releases.auto.tfvars.
  EOT
  type        = string
}

variable "extra_codeowners" {
  description = <<-EOT
    Additional CODEOWNERS entries beyond the three standard functions
    (pipeline_guardians, infrastructure_approvers, release_managers).
    Map of file path patterns to GitHub team slugs.
  EOT
  type        = map(string)
  default     = {}
}

variable "custom_properties" {
  description = <<-EOT
    Map of GitHub custom property name to configuration. Property definitions
    must already exist at the org level.
  EOT
  type = map(object({
    type  = string
    value = list(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for _, prop in var.custom_properties :
      contains(["single_select", "multi_select", "string", "true_false"], prop.type)
    ])
    error_message = "property type must be one of: single_select, multi_select, string, true_false."
  }
}

variable "archived" {
  description = "Set to true to archive the repository."
  type        = bool
  default     = false
}
