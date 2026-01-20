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
      "description" = <<-EOF
        Python library for AWS infrastructure automation - EC2 instance management,
        DynamoDB distributed locks, Route53 DNS, Secrets Manager - with cross-account
        role assumption and GitHub Actions self-hosted runner integration
      EOF
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
      "description" = <<-EOT
        Terraform module for self-hosted GitHub Actions runners on AWS EC2 with
        auto-scaling, Puppet configuration management, CloudWatch monitoring,
        and automatic runner registration/deregistration.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["github", "github-actions", "ci-cd"]
      "secrets" = {
        "CI_TEST_TOKEN" = module.github-token.secret_value
      }
      enable_pages = true
    }
    "terraform-aws-bookstack" = {
      "description" = <<-EOT
        Terraform module for BookStack wiki and documentation platform on AWS
        with RDS database, S3 storage, ALB with SSL, and OIDC authentication.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["bookstack", "wiki", "documentation"]
    }
    "terraform-aws-ci-cd" = {
      "description" = <<-EOT
        Terraform module that creates IAM roles, S3 state bucket, and DynamoDB
        lock table for Terraform CI/CD pipelines with GitHub Actions integration.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["ci-cd", "github-actions"]
    }
    "terraform-aws-cloudcraft-role" = {
      "description" = <<-EOT
        Terraform module that creates an IAM role for CloudCraft AWS
        infrastructure visualization and diagramming scanner.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["cloudcraft", "iam", "visualization"]
    }
    "terraform-aws-cloud-init" = {
      "description" = <<-EOT
        Terraform module for cloud-init configuration with Puppet integration,
        custom package installation, file provisioning, and APT repository setup.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["cloud-init", "ec2", "puppet"]
    }
    "terraform-aws-cost-alert" = {
      "description" = <<-EOT
        Terraform module for AWS Budget alerts with SNS email notifications
        for cost monitoring and threshold-based alerting.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["cost-management", "budgets", "monitoring"]
    }
    "terraform-aws-debian-repo" = {
      "description" = <<-EOT
        Terraform module for private Debian/APT repository backed by S3 with
        CloudFront CDN, GPG package signing, and Lambda-based repository indexing.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["debian", "apt", "package-repository"]
    }
    "terraform-aws-ecs" = {
      "description" = <<-EOT
        Terraform module for ECS on EC2 service deployment with ALB integration,
        auto-scaling, CloudWatch monitoring, secrets injection, and optional Datadog APM.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["ecs", "containers", "docker"]
    }
    "terraform-aws-ecr" = {
      "description" = <<-EOT
        Terraform module for AWS ECR container registry with lifecycle policies,
        image scanning, encryption, and cross-account repository access.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["ecr", "containers", "docker"]
    }
    "terraform-aws-dms" = {
      "description" = <<-EOT
        Terraform module for AWS Database Migration Service with replication
        instances, endpoints, and tasks for database migration and CDC.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["dms", "database", "migration"]
    }
    "terraform-aws-elasticsearch" = {
      "description" = <<-EOT
        Terraform module for self-managed Elasticsearch cluster on EC2 with
        auto-scaling, S3 snapshots, NLB load balancing, and CloudWatch monitoring.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["elasticsearch", "search", "logging"]
    }
    "terraform-aws-emrserverless" = {
      "description" = <<-EOT
        Terraform module for AWS EMR Serverless applications running Apache Spark
        and Hive workloads with S3 integration and IAM role configuration.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["emr", "spark", "hive", "big-data"]
    }
    "terraform-aws-kibana" = {
      "description" = <<-EOT
        Terraform module for Kibana deployment on ECS with ALB, SSL certificates,
        and Elasticsearch backend integration.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["kibana", "elasticsearch", "logging", "ecs"]
    }
    "terraform-aws-gh-identity-provider" = {
      "description" = <<-EOT
        Terraform module that configures GitHub OIDC identity provider in AWS IAM
        for secure, keyless authentication from GitHub Actions workflows.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["github", "oidc", "iam"]
    }
    "terraform-aws-gha-admin" = {
      "description" = <<-EOT
        Terraform module creating admin and read-only IAM roles for GitHub Actions
        with OIDC trust, branch-based access control, and state management permissions.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["github", "github-actions", "iam"]
    }
    "terraform-aws-github-backup" = {
      "description" = <<-EOT
        Terraform module for Lambda-based GitHub organization backup to S3 with
        scheduled execution, repository cloning, and CloudWatch monitoring.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["github", "backup", "lambda"]
    }
    "terraform-aws-github-backup-configuration" = {
      "description" = <<-EOT
        Terraform module for configuring infrahouse-github-backup GitHub App client
        with secrets, permissions, and backup target configuration.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["github", "backup"]
    }
    "terraform-aws-github-role" = {
      "description" = <<-EOT
        Terraform module that creates an IAM role with OIDC trust policy for
        GitHub Actions workflows with customizable permissions and repo/branch restrictions.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["github", "github-actions", "iam"]
    }
    "terraform-aws-guardduty-configuration" = {
      "description" = <<-EOT
        Terraform module for AWS GuardDuty threat detection with SNS email alerts,
        S3 finding exports, and configurable severity filtering.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["guardduty", "security", "monitoring"]
    }
    "terraform-aws-instance-profile" = {
      "description" = <<-EOT
        Terraform module for EC2 instance profiles with IAM role, managed policies,
        inline permissions, and optional CloudWatch/SSM integration.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["iam", "ec2", "instance-profile"]
    }
    "terraform-aws-iso27001" = {
      "description" = <<-EOT
        Terraform module for ISO 27001 compliance including CloudTrail, AWS Config,
        Security Hub, IAM password policies, and security baseline controls.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["iso27001", "compliance", "security"]
    }
    "terraform-aws-http-redirect" = {
      "description" = <<-EOT
        Terraform module for HTTP to HTTPS redirect using CloudFront
        with custom domain support and SSL certificate management.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["cloudfront", "redirect", "ssl"]
    }
    "terraform-aws-jumphost" = {
      "description" = <<-EOT
        Terraform module for bastion/jumphost EC2 instance with SSH access,
        Route53 DNS registration, security groups, and CloudWatch monitoring.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["bastion", "ssh", "ec2"]
    }
    "terraform-aws-key" = {
      "description" = <<-EOT
        Terraform module for AWS KMS encryption keys with configurable key policies,
        key rotation, aliases, and cross-account access grants.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["kms", "encryption", "security"]
    }
    "terraform-aws-lambda-monitored" = {
      "description" = <<-EOT
        Terraform module for deploying AWS Lambda functions with built-in CloudWatch monitoring,
        log retention, and least-privilege IAM role - compliant with ISO 27001
        and Vanta "Serverless function error rate monitored" requirements.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["lambda", "serverless", "monitoring"]
    }
    "terraform-aws-openvpn" = {
      "description" = <<-EOT
        Terraform module for OpenVPN Access Server on EC2 with Google OAuth/SAML
        authentication, Let's Encrypt SSL, auto-scaling, and CloudWatch monitoring.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["openvpn", "vpn", "security"]
      secrets = {
        OPENVPN_CLIENT_SECRET : module.openvpn-oauth-client-id.secret_value
      }
    }
    "terraform-aws-percona-server" = {
      "description" = <<-EOT
        Terraform module for Percona Server replica set with GTID replication,
        Orchestrator HA, and automated failover.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["percona", "mysql", "database", "replication"]
    }
    "terraform-aws-pmm-ecs" = {
      "description" = <<-EOT
        Terraform module for deploying Percona Monitoring and Management (PMM) server
        on AWS EC2 with Docker, featuring automatic SSL/TLS certificates, persistent EBS storage,
        CloudWatch monitoring, automated backups, auto-recovery, and RDS PostgreSQL monitoring support.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["pmm", "percona", "monitoring", "mysql", "postgres"]
    }
    "terraform-aws-postfix" = {
      "description" = <<-EOT
        Terraform module for Postfix MX mail server on EC2 with SpamAssassin,
        DKIM signing, SPF, DMARC, TLS encryption, and CloudWatch monitoring.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["postfix", "email", "smtp", "mail-server"]
    }
    "terraform-aws-pypiserver" = {
      "description" = <<-EOT
        Terraform module for private PyPI server on EC2 with S3 package storage,
        ALB with SSL, htpasswd authentication, and CloudWatch monitoring.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["pypi", "python", "package-registry"]
    }
    "terraform-aws-registry" = {
      "description" = <<-EOT
        Terraform module for private Terraform registry on EC2 with S3 backend,
        GitHub releases integration, ALB with SSL, and module discovery API.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["terraform-registry", "registry"]
    }
    "terraform-aws-s3-bucket" = {
      "description" = <<-EOT
        Terraform module for ISO 27001 compliant S3 bucket with server-side
        encryption, versioning, access logging, and public access blocking.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["s3", "storage", "iso27001"]
    }
    "terraform-aws-secret" = {
      "description" = <<-EOT
        Terraform module for AWS Secrets Manager secrets with owner/writer/reader
        IAM roles, automatic rotation support, and cross-account access policies.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["secrets-manager", "security"]
      auto_merge    = true
    }
    "terraform-aws-secret-policy" = {
      "description" = <<-EOT
        Terraform module that creates IAM policies for AWS Secrets Manager access
        with read, write, and admin permission levels.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["secrets-manager", "iam"]
    }
    "terraform-aws-service-network" = {
      "description" = <<-EOT
        Terraform module for VPC with public/private subnets across AZs, NAT
        gateways, internet gateway, route tables, and VPC flow logs.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["vpc", "networking", "subnets"]
    }
    "terraform-aws-sqs-pod" = {
      "description" = <<-EOT
        Terraform module for SQS queue with EC2 autoscaling group consumer,
        CloudWatch-based scaling policies, dead-letter queue, and monitoring.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["sqs", "queue", "autoscaling"]
    }
    "terraform-aws-sqs-ecs" = {
      "description" = <<-EOT
        Terraform module for SQS queue with ECS on EC2 service consumer,
        CloudWatch-based scaling, dead-letter queue, and container configuration.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["sqs", "queue", "ecs"]
    }
    "terraform-aws-state-bucket" = {
      "description" = <<-EOT
        Terraform module for S3 state bucket with DynamoDB locking table,
        server-side encryption, versioning, and access logging.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["terraform-state", "s3", "dynamodb"]
    }
    "terraform-aws-state-manager" = {
      "description" = <<-EOT
        Terraform module that creates an IAM role for Terraform state management
        with S3 bucket and DynamoDB lock table permissions.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["terraform-state", "iam"]
    }
    "terraform-aws-tags-override" = {
      "description" = <<-EOT
        Terraform module to override values in a list of name/value maps,
        useful for merging and overriding tag configurations.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["tags", "utility"]
    }
    "terraform-aws-tcp-pod" = {
      "description" = <<-EOT
        Terraform module for NLB-fronted EC2 autoscaling group serving TCP services
        with health checks, target tracking scaling, and DNS registration.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["nlb", "tcp", "autoscaling"]
    }
    "terraform-aws-teleport" = {
      "description" = <<-EOT
        Terraform module for single-node Teleport cluster providing secure SSH,
        Kubernetes, database, and application access with audit logging.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["teleport", "security", "access-management"]
    }
    "terraform-aws-teleport-agent" = {
      "description" = <<-EOT
        Terraform module for Teleport agent deployment with IAM roles and resources
        enabling AWS accounts to join an existing Teleport cluster.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["teleport", "iam"]
    }
    "terraform-aws-terraformer" = {
      "description" = <<-EOT
        Terraform module for administrative EC2 instance with cross-account AssumeRole
        capabilities for Terraform operations, DNS registration, and CloudWatch monitoring.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["ec2", "administration"]
    }
    "terraform-aws-truststore" = {
      "description" = <<-EOT
        Terraform module for ALB Trust Store with auto-generated root CA certificate,
        private key storage in Secrets Manager, and S3-backed certificate distribution.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["alb", "ssl", "certificates"]
    }
    "terraform-aws-update-dns" = {
      "description" = <<-EOT
        Terraform module for Lambda-based Route53 DNS record management that
        automatically creates/removes A records for autoscaling group instances.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["route53", "dns", "lambda"]
    }
    "terraform-aws-website-pod" = {
      "description" = <<-EOT
        Terraform module for web application deployment with ALB, ACM SSL certificates,
        EC2 autoscaling, CloudWatch alarms, CAA records, and spot instance support.
      EOT
      "type"        = "terraform_module"
      "topics"      = ["alb", "autoscaling", "website"]
    }
  }
}

module "repos" {
  source            = "./modules/plain-repo"
  for_each          = local.repos
  repo_name         = each.key
  repo_description  = replace(each.value["description"], "\n", " ")
  team_id           = github_team.dev.id
  admin_team_id     = github_team.admins.id
  public_repo       = try(each.value["public_repo"], null)
  allow_auto_merge  = try(each.value["auto_merge"], null)
  repo_type         = try(each.value["type"], null)
  anthropic_api_key = module.anthropic_api_key.secret_value
  enable_pages = try(
    each.value["enable_pages"],
    each.value["type"] == "terraform_module"
  )
  topics = concat(
    ["infrahouse"],
    each.value["type"] == "terraform_module" ? ["terraform", "terraform-module", "aws"] : [],
    each.value["type"] == "terraform_aws" ? ["terraform", "aws"] : [],
    each.value["type"] == "python_app" ? ["python"] : [],
    try(each.value["topics"], [])
  )
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
