terraform {
  backend "s3" {
    bucket = "infrahouse-github-state"
    key    = "github.state"
  }
}
