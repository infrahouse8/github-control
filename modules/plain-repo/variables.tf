variable "repo_description" {
  description = "The repository description"

  validation {
    condition     = length(regexall("[[:cntrl:]]", var.repo_description)) == 0
    error_message = <<-EOT
      Repository description cannot contain control characters (including newlines, tabs, carriage returns).
      GitHub API requires descriptions to be single-line strings.
    EOT
  }
}

variable "repo_name" {
  description = "Repository short name"
}

variable "repo_type" {
  description = "Kind of source code stored in the repository"
  default     = null
}

variable "team_id" {
  description = "Team identifier that has a push permission"
}

variable "admin_team_id" {
  description = "Team identifier that has the admin permission"
}

variable "secrets" {
  description = "Map with GitHub Action secrets"
  type        = map(string)
  default     = {}
}

variable "public_repo" {
  description = "True if the repo is public."
  type        = bool
  default     = true
  nullable    = false
}

variable "allow_auto_merge" {
  description = "Merge pull requests automatically if all statuses are successful"
  type        = bool
  default     = false
}

variable "use_merge_queue" {
  description = "Set to true to enable merge queue in the repository"
  type        = bool
  default     = false
  nullable    = false
}

variable "dismiss_stale_reviews" {
  description = "Whether to dismiss stale reviews"
  default     = true
  nullable    = false
}

variable "require_code_owner_reviews" {
  description = "If set to true CODEOWNERS must approve a pull request"
  default     = true
  type        = bool
  nullable    = false
}

variable "approvals_count" {
  description = "Number of approvals required for PR"
  default     = 1
  nullable    = false
}
