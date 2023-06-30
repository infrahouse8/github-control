variable "archived" {
  description = "Specifies if the repository should be archived. Defaults to false."
  type        = bool
  default     = false
}
variable "checks" {
  description = "Required pull request checks"
  type        = list(string)
  default = [
    "Terraform Plan",
  ]
}

variable "collaborators" {
  description = "List of users who have a push privilege"
  type        = list(string)
  default     = []
}

variable "repo_description" {
  description = "The repository description"
}

variable "repo_name" {
  description = "Repository short name"
}

variable "template_repo" {
  description = "Repository name to use as a template"
  default     = "terraform-template"
}

variable "secrets" {
  description = "Map with GitHub Action secrets"
  type        = map(string)
  default     = {}
}