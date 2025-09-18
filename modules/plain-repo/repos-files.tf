locals {
  vuln_scanner_workflow = var.public_repo ? "vuln-scanner-pr-public.yml" : "vuln-scanner-pr-private.yml"

}
resource "github_repository_file" "vuln_scanner_workflow" {
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.repo.name
  file                = "./.github/workflows/vuln-scanner-pr.yml"
  content             = file("${path.module}/files/${local.vuln_scanner_workflow}")
  commit_message      = "Update vuln-scanner-pr.yml workflow"
  overwrite_on_create = true
}
