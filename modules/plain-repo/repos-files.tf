locals {
  vuln_scanner_workflow = var.public_repo ? "vuln-scanner-pr-public.yml" : "vuln-scanner-pr-private.yml"
}

resource "github_repository_file" "renovate_json" {
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.repo.name
  file                = "renovate.json"
  content             = file("${path.module}/files/renovate.json")
  commit_message      = "Configure renovate"
  overwrite_on_create = true
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

resource "github_repository_file" "terraform_module_reviewer" {
  count = var.repo_type == "terraform_module" ? 1 : 0
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.repo.name
  file                = "./.claude/agents/terraform-module-reviewer.md"
  content             = file("${path.module}/files/terraform-module-reviewer.md")
  commit_message      = "Add terraform-module-reviewer Claude agent"
  overwrite_on_create = true
}

resource "github_repository_file" "coding_standard" {
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.repo.name
  file                = "./.claude/CODING_STANDARD.md"
  content             = file("${path.module}/files/CODING_STANDARD.md")
  commit_message      = "Add CODING_STANDARD.md"
  overwrite_on_create = true
}

resource "github_repository_file" "claude_instructions" {
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.repo.name
  file                = "./.claude/instructions.md"
  content             = file("${path.module}/files/instructions.md")
  commit_message      = "Add Claude Code instructions"
  overwrite_on_create = true
}

resource "github_repository_file" "makefile_example" {
  count = var.repo_type == "terraform_module" ? 1 : 0
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.repo.name
  file                = "./.claude/Makefile-example"
  content             = file("${path.module}/files/Makefile-example")
  commit_message      = "Add Makefile-example"
  overwrite_on_create = true
}

resource "github_repository_file" "terraform_review_workflow" {
  count = var.repo_type == "terraform_module" ? 1 : 0
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.repo.name
  file                = "./.github/workflows/terraform-review.yml"
  content             = file("${path.module}/files/terraform-review.yml")
  commit_message      = "Add terraform-review.yml workflow"
  overwrite_on_create = true
}

resource "github_repository_file" "terraform_docs_config" {
  count = var.repo_type == "terraform_module" ? 1 : 0
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.repo.name
  file                = "./.terraform-docs.yml"
  content             = file("${path.module}/files/.terraform-docs.yml")
  commit_message      = "Add .terraform-docs.yml configuration"
  overwrite_on_create = true
}

resource "github_repository_file" "cliff_config" {
  count = var.repo_type == "terraform_module" ? 1 : 0
  depends_on = [
    github_repository_ruleset.main
  ]
  repository = github_repository.repo.name
  file       = "./cliff.toml"
  content = templatefile("${path.module}/files/cliff.toml.tpl", {
    repo_name = github_repository.repo.name
  })
  commit_message      = "Add cliff.toml configuration"
  overwrite_on_create = true
}

resource "github_repository_file" "pre_commit_hook" {
  count = var.repo_type == "terraform_module" ? 1 : 0
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.repo.name
  file                = "./hooks/pre-commit"
  content             = file("${path.module}/files/pre-commit")
  commit_message      = "Add pre-commit hook"
  overwrite_on_create = true
}

resource "github_repository_file" "commit_msg_hook" {
  count = var.repo_type == "terraform_module" ? 1 : 0
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.repo.name
  file                = "./hooks/commit-msg"
  content             = file("${path.module}/files/commit-msg")
  commit_message      = "Add commit-msg hook"
  overwrite_on_create = true
}

resource "github_repository_file" "docs_workflow" {
  count = var.repo_type == "terraform_module" ? 1 : 0
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.repo.name
  file                = "./.github/workflows/docs.yml"
  content             = file("${path.module}/files/docs.yml")
  commit_message      = "Add docs.yml workflow for GitHub Pages"
  overwrite_on_create = true
}

resource "github_repository_file" "release_workflow" {
  count = var.repo_type == "terraform_module" ? 1 : 0
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.repo.name
  file                = "./.github/workflows/release.yml"
  content             = file("${path.module}/files/release.yml")
  commit_message      = "Add release.yml workflow"
  overwrite_on_create = true
}

resource "github_repository_file" "security_md" {
  count = var.repo_type == "terraform_module" ? 1 : 0
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.repo.name
  file                = "SECURITY.md"
  content             = file("${path.module}/files/SECURITY.md")
  commit_message      = "Add SECURITY.md"
  overwrite_on_create = true
}

resource "github_repository_file" "docs_index" {
  count = var.repo_type == "terraform_module" ? 1 : 0
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.repo.name
  file                = "./docs/index.md"
  content             = "# ${github_repository.repo.name}\n\n${github_repository.repo.description}\n"
  commit_message      = "Add docs/index.md"
  overwrite_on_create = false

  lifecycle {
    ignore_changes = [content]
  }
}

resource "github_repository_file" "mkdocs_config" {
  count = var.repo_type == "terraform_module" ? 1 : 0
  depends_on = [
    github_repository_ruleset.main
  ]
  repository = github_repository.repo.name
  file       = "./mkdocs.yml"
  content = templatefile("${path.module}/files/mkdocs.yml.tpl", {
    repo_name = github_repository.repo.name
  })
  commit_message      = "Add mkdocs.yml configuration"
  overwrite_on_create = false

  lifecycle {
    ignore_changes = [content]
  }
}
