resource "github_branch_protection" "main" {
  pattern        = github_branch_default.main.branch
  repository_id  = github_repository.repo.node_id
  enforce_admins = false

  required_pull_request_reviews {
    dismiss_stale_reviews           = var.dismiss_stale_reviews
    required_approving_review_count = var.approvals_count
    require_code_owner_reviews      = var.require_code_owner_reviews
    pull_request_bypassers = [
      data.github_app.github-terraform.node_id
    ]
  }
}

resource "github_repository_ruleset" "main" {
  name        = "Main Branch Protection"
  repository  = github_repository.repo.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }
  bypass_actors {
    actor_id    = data.github_app.github-terraform.id
    actor_type  = "Integration"
    bypass_mode = "always"
  }

  rules {
    required_status_checks {
      strict_required_status_checks_policy = true
      dynamic "required_check" {
        for_each = toset(
          concat(
            var.repo_type == "terraform_aws" ? ["Terraform Plan"] : [],
            [
              # "vulnerability-check / osv-scan",
            ]
          )
        )
        content {
          context = required_check.key
        }
      }
    }
    dynamic "merge_queue" {
      for_each = toset(
        var.use_merge_queue ? [1] : []
      )
      content {
        check_response_timeout_minutes    = 5
        grouping_strategy                 = "ALLGREEN"
        max_entries_to_build              = 5
        max_entries_to_merge              = 5
        merge_method                      = "SQUASH"
        min_entries_to_merge              = 1
        min_entries_to_merge_wait_minutes = 5
      }
    }

    pull_request {
      dismiss_stale_reviews_on_push   = var.dismiss_stale_reviews
      require_code_owner_review       = var.require_code_owner_reviews
      required_approving_review_count = var.approvals_count
    }
  }
}
