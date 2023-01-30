# github-control
InfraHouse GitHub configuration.
The repository is available as a public repository of a user [infrahouse8](https://github.com/infrahouse8).
The repository's URL is https://github.com/infrahouse8/github-control.

## Workflow

When a user creates a pull request, GitHub Actions triggers a `terraform plan` for a review.
When the pull requests is merged GitHub Actions triggers another workflow, `terraform apply` to deploy the changes.


## Input secrets and variables

The repo needs a set of input available for in the PR stage as well as for deployment.
Some inputs are secrets, some - variables.

### Secrets

Defined in https://github.com/infrahouse8/github-control/settings/secrets/actions.

* `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION` - AWS credentials of a user that has privileges 
to work with a Terraform state in S3. Minimal privileges required:
    * ListBucket
    * GetObject
    * PutObject
    * DeleteObject
* `GH_TOKEN` - personal token of a user `infrahouse8`. Defined in https://github.com/settings/tokens.

## Variables

Defined in https://github.com/infrahouse8/github-control/settings/variables/actions.

* `STATES_BUCKET` - a name of an S3 bucket that stores the Terraform state e.g. `infrahouse-github-state`.
