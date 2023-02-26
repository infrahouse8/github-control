provider "github" {
  owner = "infrahouse"
}

provider "github" {
  owner = "infrahouse8"
  alias = "infrahouse8"
}

provider "aws" {
  region = "us-west-1"
  assume_role {
    role_arn = "arn:aws:iam::990466748045:role/github-admin"
  }
}

provider "aws" {
  region = "us-west-1"
  alias  = "uw1"
  assume_role {
    role_arn = "arn:aws:iam::990466748045:role/github-admin"
  }
}

provider "aws" {
  region = "us-west-2"
  alias  = "uw2"
  assume_role {
    role_arn = "arn:aws:iam::990466748045:role/github-admin"
  }
}
