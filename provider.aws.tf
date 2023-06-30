provider "aws" {
  alias  = "aws-303467602807-uw1"
  region = "us-west-1"
  assume_role {
    role_arn = "arn:aws:iam::303467602807:role/ih-tf-cicd-control"
  }
}

provider "aws" {
  alias  = "aws-303467602807-uw2"
  region = "us-west-1"
  assume_role {
    role_arn = "arn:aws:iam::303467602807:role/ih-tf-cicd-control"
  }
}
