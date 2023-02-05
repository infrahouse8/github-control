variable "developers" {
  description = "List of members of the developers team. They will be invited to the organization as well."
  default     = []
  type        = list(string)
}
