provider "github" {
  owner = "infrahouse"
}

provider "aws" {
  region = "us-west-1"
  alias  = "uw1"
}

provider "aws" {
  region = "us-west-2"
  alias  = "uw2"
}
