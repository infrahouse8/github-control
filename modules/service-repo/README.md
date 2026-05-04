# service-repo

Terraform module that creates and configures a GitHub repository for deploying
Terraform infrastructure to one or more AWS environments.

The module is a pure GitHub module — it has no AWS provider dependency. IAM roles
and the state bucket are created by the caller and passed in via `var.environments`
and `var.state_bucket`.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
