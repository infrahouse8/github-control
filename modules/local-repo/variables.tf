variable "repo_description" {
  description = "The repository description"
}

variable "repo_name" {
  description = "Repository short name"
}

variable "checks" {
  description = "Required pull request checks"
  type        = list(string)
  default = [
    "Terraform Plan",
  ]
}
