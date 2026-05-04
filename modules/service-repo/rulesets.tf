resource "github_repository_ruleset" "main" {
  name        = "Main Branch Protection"
  repository  = github_repository.this.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  bypass_actors {
    actor_id    = data.github_app.terraform.id
    actor_type  = "Integration"
    bypass_mode = "always"
  }

  rules {
    required_status_checks {
      strict_required_status_checks_policy = true
      dynamic "required_check" {
        for_each = toset(local.required_checks)
        content {
          context = required_check.key
        }
      }
    }

    pull_request {
      dismiss_stale_reviews_on_push   = true
      require_code_owner_review       = true
      required_approving_review_count = var.approvals_count
    }
  }
}
