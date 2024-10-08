locals {
  repos = {
    "aws-control" = {
      "description" = "InfraHouse Main AWS Account 990466748045."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_aws"
    }
    "aws-control-289256138624" = {
      "description" = "InfraHouse Terraform Control AWS Account 289256138624."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_aws"
    }
    "aws-control-303467602807" = {
      "description" = "InfraHouse CI/CD AWS Account 303467602807."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_aws"
    }
    "aws-control-493370826424" = {
      "description" = "InfraHouse Management AWS Account 493370826424."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_aws"
    }
    "cookiecutter-github-control" = {
      "description" = "Template for a GitHub Control repository."
      "team_id"     = github_team.dev.id
      "type"        = "other"
    }
    "infrahouse-com" = {
      "description" = "InfraHouse.com content."
      "secrets" = {
        "AWS_DEFAULT_REGION" = local.aws_default_region
      }
      "team_id" = github_team.dev.id
      "type"    = "other"
    }
    "infrahouse-puppet-data" = {
      "description" = "InfraHouse Puppet Hiera Data."
      "secrets" = {
        "AWS_DEFAULT_REGION" = local.aws_default_region
      }
      "team_id" = github_team.dev.id
      "type"    = "other"
    }
    "infrahouse-toolkit" = {
      "description" = "InfraHouse Toolkit."
      "secrets" = {
        "CODACY_PROJECT_TOKEN" = data.aws_secretsmanager_secret_version.codacy_api_token.secret_string
        "PYPI_API_TOKEN"       = data.aws_secretsmanager_secret_version.pypi_api_token.secret_string
      }
      "team_id" = github_team.dev.id
      "type"    = "python_app"
    }
    "hiera-aws-sm" = {
      "description" = "A Hiera 5 backend for AWS Secrets Manager(accenture/hiera-aws-sm fork)."
      "team_id"     = github_team.dev.id
      "type"        = "other"
    }
    "homebrew-infrahouse-toolkit" = {
      "description" = "Homebrew Formula for infrahouse-toolkit"
      "team_id"     = github_team.dev.id
      "type"        = "other"
    }
    "infrahouse-website-infra" = {
      "description" = "InfraHouse Website Infrastructure."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_aws"
    }
    "proxysql-sandbox" = {
      "description" = "Terraform live module to deploy ProxySQL sandbox on AWS."
      "team_id"     = github_team.dev.id
      "type"        = "other"
    }
    "puppet-code" = {
      "description" = "Puppet Configuration. Modules and Manifests. Hiera has moved to infrahouse-puppet-data."
      "secrets" = {
        "AWS_DEFAULT_REGION" = local.aws_default_region
      }
      "team_id" = github_team.dev.id
      "type"    = "other"
    }
    "terraform-aws-actions-runner" = {
      "description" = "Module that deploys self-hosted GitHub Actions runner."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-aerospike" = {
      "description" = "Module that deploys Aerospike cluster."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-bookstack" = {
      "description" = "Module that deploys BookStack."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-ci-cd" = {
      "description" = "Module that creates roles, state bucket, and dynamodb table for Terraform CI/CD."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-cloud-init" = {
      "description" = "Module that creates an cloud init configuration for an InfraHouse EC2 instance."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-debian-repo" = {
      "description" = "Module that creates a Debian repository backed by S3 and fronted by CloudFront."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-ecs" = {
      "description" = "Module that runs service in ECS"
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-elasticsearch" = {
      "description" = "Module that deploys an Elasticsearch cluster"
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-kibana" = {
      "description" = "Module that deploys Kibana"
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-gh-identity-provider" = {
      "description" = "Module that configures GitHub OpenID connector."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-gha-admin" = {
      "description" = "Module for two roles to manage AWS with GitHub actions."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-github-backup" = {
      "description" = "Module to provision infrahouse-github-backup GitHub App."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-github-role" = {
      "description" = "Module that creates a role for a GitHub Action worker."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-instance-profile" = {
      "description" = "Module bundles AWS resources to create an instance profile."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-jumphost" = {
      "description" = "Module that creates a jumphost."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-openvpn" = {
      "description" = "Terraform module that deploys OpenVPN server."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-postfix" = {
      "description" = "Terraform module that deploys Postfix as a MX server."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-pypiserver" = {
      "description" = "Terraform module that deploys a private PyPI server."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-secret" = {
      "description" = "Terraform module for a secret with owner/writer/reader roles."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-secret-policy" = {
      "description" = "Terraform module that creates AWS secret permissions policy."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-service-network" = {
      "description" = "Terraform service network module."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-state-bucket" = {
      "description" = "Module that creates an S3 bucket for a Terraform state."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-state-manager" = {
      "description" = "Module creates an IAM role that can manage a Terraform state."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-tags-override" = {
      "description" = "Module to override tags list for ECS"
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-terraformer" = {
      "description" = "Module that deploys an instances allowed to manage Terraform root modules."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-update-dns" = {
      "description" = "Module creates a lambda that manages DNS A records for instances in an autoscaling group."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
    "terraform-aws-website-pod" = {
      "description" = "Module that creates an autoscaling group with an ALB and SSL certificate for a website."
      "team_id"     = github_team.dev.id
      "type"        = "terraform_module"
    }
  }
}

module "repos" {
  source           = "./modules/plain-repo"
  for_each         = local.repos
  repo_name        = each.key
  repo_description = each.value["description"]
  team_id          = each.value["team_id"]
  secrets = merge(
    contains(keys(each.value), "secrets") ? each.value["secrets"] : {},
    merge(
      {
        GH_TOKEN = data.external.env.result["GH_TOKEN"]
      },
      contains(["terraform_aws", "python_app"], each.value["type"]) ?
      {
        AWS_DEFAULT_REGION = local.aws_default_region

      } :
      {}
    )
  )
}

module "ih_tf_template" {
  source = "./modules/repo-template"
  repo_description = join(
    " ",
    [
      "Template repository for a Terraform project.",
      "This repository is not supposed to become a cookiecutter.",
      "If you need one - check out https://github.com/infrahouse/cookiecutter-github-control .",
      "This repository will be used as a template to instantiate a new empty Terraform repository."
    ]
  )
  repo_name = "terraform-template"
  team_id   = github_team.dev.id
}
