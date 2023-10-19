variable "developers" {
  description = "List of members of the developers team. They will be invited to the organization as well."
  default     = []
  type        = list(string)
}

variable "default_tags" {
  description = "A map with tags that will be applied to all resources created by the AWS provider"
  type        = map(string)
}

variable "role_admin" {
  description = "Role in the principal AWS account"
}
