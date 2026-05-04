locals {
  default_branch = "main"

  required_checks = concat(
    [for env in keys(var.environments) : "Terraform Plan ${env}"],
    ["TruffleHog", "vulnerability-check"],
    var.checks,
  )
}
