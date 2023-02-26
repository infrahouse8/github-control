locals {
  infrahouse_8_repos = {
    "github-control" : {
      description = "InfraHouse GitHub configuration"
      role        = "arn:aws:iam::990466748045:role/github-admin"
    }
    "aws-s3-control" : {
      description = "InfraHouse Terraform State Buckets"
    }
  }
}

module "ih_8_repos" {
  source           = "./modules/local-repo"
  for_each         = local.infrahouse_8_repos
  repo_name        = each.key
  repo_description = each.value["description"]
  role             = contains(keys(each.value), "role") ? each.value["role"] : null

  providers = {
    github = github.infrahouse8
  }
}
