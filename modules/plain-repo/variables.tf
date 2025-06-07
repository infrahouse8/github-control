variable "repo_description" {
  description = "The repository description"
}

variable "repo_name" {
  description = "Repository short name"
}

variable "team_id" {
  description = "Team identifier that has a push permission"
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
