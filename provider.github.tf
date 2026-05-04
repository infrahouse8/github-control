provider "github" {
  owner = "infrahouse"
  app_auth {
    id              = "1016363"
    installation_id = "55607614"
    pem_file        = local.infrahouse-github-terraform-pem
  }
}

locals {
  infrahouse-github-terraform-pem = file("${path.module}/.env/infrahouse-github-terraform.pem")
}

provider "github" {
  owner = "infrahouse8"
  alias = "infrahouse8"
  app_auth {
    id              = "1016363"
    installation_id = "55799033"
    pem_file        = local.infrahouse-github-terraform-pem
  }
}
