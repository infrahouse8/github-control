variable "repo_description" {
  description = "The repository description"
}

variable "repo_name" {
  description = "Repository short name"
}

variable "team_id" {
  description = "Team identifier that has a push permission"
  default     = null
}
