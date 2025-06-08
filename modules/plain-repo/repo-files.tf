resource "github_repository_file" "renovate-json" {
  count               = var.repo_type == "terraform_module" ? 1 : 0
  repository          = github_repository.repo.name
  file                = "renovate.json"
  content             = file("${path.module}/files/renovate.json")
  commit_message      = "Configure renovate"
  overwrite_on_create = true
}
