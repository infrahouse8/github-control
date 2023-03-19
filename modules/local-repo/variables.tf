variable "checks" {
  description = "Required pull request checks"
  type        = list(string)
  default = [
    "Terraform Plan",
  ]
}

variable "collaborators" {
  description = "List of user who have push privilege"
  type        = list(string)
  default     = []
}

variable "repo_description" {
  description = "The repository description"
}

variable "repo_name" {
  description = "Repository short name"
}

variable "role" {
  description = "AWS role ARN to be saved in a repo secret"
  type        = string
  default     = null
}

variable "template_repo" {
  description = "Repository name to use as a template"
  default     = "terraform-template"
}
