provider "github" {
  owner = "infrahouse"
  app_auth {
    id              = "1016363"
    installation_id = "55607614"
    pem_file        = module.infrahouse-github-terraform-pem.secret_value
  }
}

provider "github" {
  owner = "infrahouse8"
  alias = "infrahouse8"
  app_auth {
    id              = "1016363"
    installation_id = "55799033"
    pem_file        = module.infrahouse-github-terraform-pem.secret_value
  }
}
