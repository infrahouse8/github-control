variable "default_tags" {
  description = "A map with tags that will be applied to all resources created by the AWS provider"
  type        = map(string)
}

variable "role_admin" {
  description = "Role in the principal AWS account"
}
