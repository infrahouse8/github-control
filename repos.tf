locals {
  repos = {
    "aws-control" = {
      "description" = "InfraHouse Main AWS Account 990466748045."
      "type"        = "terraform_aws"
    }
    "aws-control-289256138624" = {
      "description" = "InfraHouse Terraform Control AWS Account 289256138624."
      "type"        = "terraform_aws"
    }
    "aws-control-303467602807" = {
      "description" = "InfraHouse CI/CD AWS Account 303467602807."
      "type"        = "terraform_aws"
    }
    "aws-control-493370826424" = {
      "description" = "InfraHouse Management AWS Account 493370826424."
      "type"        = "terraform_aws"
    }
    "cookiecutter-github-control" = {
      "description" = "Template for a GitHub Control repository."
      "type"        = "other"
    }
    "infrahouse-com" = {
      "description" = "InfraHouse.com content."
      "secrets" = {
        "AWS_DEFAULT_REGION" = local.aws_default_region
      }
      "type"      = "other"
      public_repo = false
    }
    "infrahouse-core" = {
      "description" = "Python library with AWS classes."
      "secrets" = {
        "PYPI_API_TOKEN" = data.aws_secretsmanager_secret_version.pypi_api_token.secret_string
      }
      "type" = "python_app"

    }
    "infrahouse-puppet-data" = {
      "description" = "InfraHouse Puppet Hiera Data."
      "secrets" = {
        "AWS_DEFAULT_REGION" = local.aws_default_region
      }
      "type" = "other"
    }
    "infrahouse-toolkit" = {
      "description" = "InfraHouse Toolkit."
      "secrets" = {
        "CODACY_PROJECT_TOKEN" = data.aws_secretsmanager_secret_version.codacy_api_token.secret_string
        "PYPI_API_TOKEN"       = data.aws_secretsmanager_secret_version.pypi_api_token.secret_string
      }
      "type" = "python_app"
    }
    "infrahouse-ubuntu-pro" = {
      "description" = "Ubuntu Pro AMI with InfraHouse packages."
      "type"        = "other"
    }
    "hiera-aws-sm" = {
      "description" = "A Hiera 5 backend for AWS Secrets Manager(accenture/hiera-aws-sm fork)."
      "type"        = "other"
    }
    "homebrew-infrahouse-toolkit" = {
      "description" = "Homebrew Formula for infrahouse-toolkit"
      "type"        = "other"
    }
    "infrahouse-website-infra" = {
      "description" = "InfraHouse Website Infrastructure."
      "type"        = "terraform_aws"
    }
    "osv-scanner" = {
      "description" = "Vulnerability scanner written in Go which uses the data provided by https://osv.dev"
      "type"        = "other"
      "secrets" = {
        "AWS_DEFAULT_REGION" = local.aws_default_region
      }
    }
    "prometheus-elasticsearch-exporter" = {
      "description" = "InfraHouse fork of Elasticsearch stats exporter for Prometheus."
      "type"        = "other"
    }
    "proxysql-sandbox" = {
      "description" = "Terraform live module to deploy ProxySQL sandbox on AWS."
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
    "pytest-infrahouse" = {
      "description" = "InfraHouse Pytest Plugin."
      "secrets" = {
        "PYPI_API_TOKEN" = data.aws_secretsmanager_secret_version.pypi_api_token.secret_string
      }
      "type" = "python_app"

    }
    "terraform-aws-actions-runner" = {
      "description" = "Module that deploys self-hosted GitHub Actions runner."
      "type"        = "terraform_module"
      "secrets" = {
        "CI_TEST_TOKEN" = module.github-token.secret_value
      }
    }
    "terraform-aws-aerospike" = {
      "description" = "Module that deploys Aerospike cluster."
      "type"        = "terraform_module"
    }
    "terraform-aws-bookstack" = {
      "description" = "Module that deploys BookStack."
      "type"        = "terraform_module"
    }
    "terraform-aws-ci-cd" = {
      "description" = "Module that creates roles, state bucket, and dynamodb table for Terraform CI/CD."
      "type"        = "terraform_module"
    }
    "terraform-aws-cloudcraft-role" = {
      "description" = "Module that creates a role for CloudCraft scanner."
      "type"        = "terraform_module"
    }
    "terraform-aws-cloud-init" = {
      "description" = "Module that creates a cloud init configuration for an InfraHouse EC2 instance."
      "type"        = "terraform_module"
    }
    "terraform-aws-cost-alert" = {
      "description" = "Module that creates a alert for AWS cost per period."
      "type"        = "terraform_module"
    }
    "terraform-aws-debian-repo" = {
      "description" = "Module that creates a Debian repository backed by S3 and fronted by CloudFront."
      "type"        = "terraform_module"
    }
    "terraform-aws-ecs" = {
      "description" = "Module that runs service in ECS"
      "type"        = "terraform_module"
    }
    "terraform-aws-ecr" = {
      "description" = "Module that creates a container registry (AWS ECR service)."
      "type"        = "terraform_module"
    }
    "terraform-aws-dms" = {
      "description" = "Module for deploying AWS Data Migration Service"
      "type"        = "terraform_module"
    }
    "terraform-aws-elasticsearch" = {
      "description" = "Module that deploys an Elasticsearch cluster"
      "type"        = "terraform_module"
    }
    "terraform-aws-emrserverless" = {
      "description" = "Module for deploying EMR serverless"
      "type"        = "terraform_module"
    }
    "terraform-aws-kibana" = {
      "description" = "Module that deploys Kibana"
      "type"        = "terraform_module"
    }
    "terraform-aws-gh-identity-provider" = {
      "description" = "Module that configures GitHub OpenID connector."
      "type"        = "terraform_module"
    }
    "terraform-aws-gha-admin" = {
      "description" = "Module for two roles to manage AWS with GitHub actions."
      "type"        = "terraform_module"
    }
    "terraform-aws-github-backup" = {
      "description" = "Module to provision infrahouse-github-backup GitHub App."
      "type"        = "terraform_module"
    }
    "terraform-aws-github-backup-configuration" = {
      "description" = "Module that configures infrahouse-github-backup GitHub App client."
      "type"        = "terraform_module"
    }
    "terraform-aws-github-role" = {
      "description" = "Module that creates a role for a GitHub Action worker."
      "type"        = "terraform_module"
    }
    "terraform-aws-guardduty-configuration" = {
      "description" = "Module that configures GuardDuty and email notifications."
      "type"        = "terraform_module"
    }
    "terraform-aws-instance-profile" = {
      "description" = "Module bundles AWS resources to create an instance profile."
      "type"        = "terraform_module"
    }
    "terraform-aws-iso27001" = {
      "description" = "Module configures ISO 27001 compliance for AWS."
      "type"        = "terraform_module"
    }
    "terraform-aws-http-redirect" = {
      "description" = "Module creates an HTTP redirect server."
      "type"        = "terraform_module"
    }
    "terraform-aws-jumphost" = {
      "description" = "Module that creates a jumphost."
      "type"        = "terraform_module"
    }
    "terraform-aws-key" = {
      "description" = "Module that creates an encryption key in KMS."
      "type"        = "terraform_module"
    }
    "terraform-aws-lambda-monitored" = {
      "description" = <<-EOT
        Terraform module for deploying AWS Lambda functions with built-in CloudWatch monitoring,
        log retention, and least-privilege IAM role - compliant with ISO 27001
        and Vanta "Serverless function error rate monitored" requirements.
      EOT
      "type"        = "terraform_module"
    }
    "terraform-aws-openvpn" = {
      "description" = "Terraform module that deploys OpenVPN server."
      "type"        = "terraform_module"
      secrets = {
        OPENVPN_CLIENT_SECRET : module.openvpn-oauth-client-id.secret_value
      }
    }
    "terraform-aws-pmm-ecs" = {
      "description" = <<-EOT
        Terraform module for deploying Percona Monitoring and Management (PMM) server
        on AWS ECS with persistent EFS storage, automatic SSL,
        and RDS PostgreSQL monitoring support.
      EOT
      "type"        = "terraform_module"
    }
    "terraform-aws-postfix" = {
      "description" = "Terraform module that deploys Postfix as a MX server."
      "type"        = "terraform_module"
    }
    "terraform-aws-pypiserver" = {
      "description" = "Terraform module that deploys a private PyPI server."
      "type"        = "terraform_module"
    }
    "terraform-aws-registry" = {
      "description" = "Terraform module that deploys a private Terraform registry."
      "type"        = "terraform_module"
    }
    "terraform-aws-s3-bucket" = {
      "description" = "Terraform module for an ISO27001 compliant S3 bucket."
      "type"        = "terraform_module"
    }
    "terraform-aws-secret" = {
      "description" = "Terraform module for a secret with owner/writer/reader roles."
      "type"        = "terraform_module"
      auto_merge    = true
    }
    "terraform-aws-secret-policy" = {
      "description" = "Terraform module that creates AWS secret permissions policy."
      "type"        = "terraform_module"
    }
    "terraform-aws-service-network" = {
      "description" = "Terraform service network module."
      "type"        = "terraform_module"
    }
    "terraform-aws-sqs-pod" = {
      "description" = "Terraform module deploys an SQS queue with autoscaling group as a consumer."
      "type"        = "terraform_module"
    }
    "terraform-aws-sqs-ecs" = {
      "description" = "Terraform module deploys an SQS queue with ECS service as a consumer."
      "type"        = "terraform_module"
    }
    "terraform-aws-state-bucket" = {
      "description" = "Module that creates an S3 bucket for a Terraform state."
      "type"        = "terraform_module"
    }
    "terraform-aws-state-manager" = {
      "description" = "Module creates an IAM role that can manage a Terraform state."
      "type"        = "terraform_module"
    }
    "terraform-aws-tags-override" = {
      "description" = "Module to override tags list for ECS"
      "type"        = "terraform_module"
    }
    "terraform-aws-tcp-pod" = {
      "description" = "Module that creates an autoscaling group with an NLB for a TCP based services."
      "type"        = "terraform_module"
    }
    "terraform-aws-teleport" = {
      "description" = "Module deploys a single node Teleport cluster."
      "type"        = "terraform_module"
    }
    "terraform-aws-teleport-agent" = {
      "description" = "Module deploys roles and other resources on an account joining Teleport cluster."
      "type"        = "terraform_module"
    }
    "terraform-aws-terraformer" = {
      "description" = "Module that deploys an instances allowed to manage Terraform root modules."
      "type"        = "terraform_module"
    }
    "terraform-aws-truststore" = {
      "description" = "Module that creates a trust store with a generated CA certificate."
      "type"        = "terraform_module"
    }
    "terraform-aws-update-dns" = {
      "description" = "Module creates a lambda that manages DNS A records for instances in an autoscaling group."
      "type"        = "terraform_module"
    }
    "terraform-aws-website-pod" = {
      "description" = "Module that creates an autoscaling group with an ALB and SSL certificate for a website."
      "type"        = "terraform_module"
    }
  }
}

module "repos" {
  source           = "./modules/plain-repo"
  for_each         = local.repos
  repo_name        = each.key
  repo_description = replace(each.value["description"], "\n", " ")
  team_id          = github_team.dev.id
  admin_team_id    = github_team.admins.id
  public_repo      = try(each.value["public_repo"], null)
  allow_auto_merge = try(each.value["auto_merge"], null)
  repo_type        = try(each.value["type"], null)
  secrets = merge(
    contains(keys(each.value), "secrets") ? each.value["secrets"] : {},
    merge(
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
