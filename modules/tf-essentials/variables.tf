#variable "admin_policy_name" {
#  description = "Name of the IAM policy the `ih-tf-{var.repo_name}-admin` role will have. This is what the role can do."
#  type = string
#  default = "AdministratorAccess"
#}
#
#variable "admin_allowed_arns" {
#  description = "A list of ARNs besides `ih-tf-{var.repo_name}-github` that are allowed to assume the `ih-tf-{var.repo_name}-admin` role."
#  type = list(string)
#  default = []
#}

variable "gh_org" {
  description = "GitHub organization name."
  type        = string
}

variable "gh_repo" {
  description = "Repository name in GitHub. Without the organization part."
}
