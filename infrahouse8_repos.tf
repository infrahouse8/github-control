locals {
  infrahouse_8_repos = {
    "github-control" : {
      description = "InfraHouse GitHub configuration"
    }
  }
}

module "ih_8_repos" {
  source           = "./modules/local-repo"
  for_each         = local.infrahouse_8_repos
  repo_name        = each.key
  repo_description = each.value["description"]

  providers = {
    github = github.infrahouse8
  }
}
