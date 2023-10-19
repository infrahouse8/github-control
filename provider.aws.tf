provider "aws" {
  alias  = "aws-303467602807-uw1"
  region = "us-west-1"
  assume_role {
    role_arn = var.role_admin
  }
  default_tags {
    tags = var.default_tags
  }

}

provider "aws" {
  alias  = "aws-303467602807-uw2"
  region = "us-west-1"
  assume_role {
    role_arn = var.role_admin
  }
  default_tags {
    tags = var.default_tags
  }
}

provider "aws" {
  alias  = "aws-289256138624-uw1"
  region = "us-west-1"
  assume_role {
    role_arn = "arn:aws:iam::289256138624:role/ih-tf-terraform-control"
  }
  default_tags {
    tags = var.default_tags
  }
}
