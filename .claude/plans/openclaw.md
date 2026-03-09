# terraform-aws-openclaw

Terraform module for deploying [OpenClaw](https://github.com/openclaw)
AI agent gateway on AWS with ALB, Cognito authentication, and
multi-provider LLM support (Bedrock, Anthropic API, OpenAI API,
Ollama).

---

## Problem Statement

Running an AI agent gateway in AWS requires stitching together many
services: ALB with TLS, Cognito for authentication, IAM for Bedrock
access, Secrets Manager for API keys, EFS for persistent config,
CloudWatch for logging, and cloud-init for instance bootstrapping.

Each piece has non-obvious requirements:
- Bedrock models need inference profile IDs (`us.` prefix), not
  foundation model IDs
- Bedrock auto-subscription needs Marketplace IAM permissions
- OpenClaw's trusted-proxy auth needs ALB subnet CIDRs
- Ollama models must fit in instance RAM or the instance swaps to
  death
- Config must survive instance replacement (EFS) while letting
  Terraform manage infrastructure settings (deep-merge)

This module packages all of that into a single `module` block.

---

## Requirements Summary

### Networking
- ALB in public subnets (minimum 2 AZs) with ACM certificate
- EC2 instance in private subnet(s) behind ALB
- Security group isolation: backend accepts traffic only from ALB
- DNS A record(s) in Route53

### Authentication
- Cognito user pool with email-based login
- ALB authenticate-cognito action on HTTPS listener
- OpenClaw trusted-proxy auth mode trusting ALB's
  `x-amzn-oidc-identity` header
- Trusted proxy CIDRs auto-derived from ALB subnets

### LLM Providers
- **AWS Bedrock**: IAM role with invoke permissions on all foundation
  models and inference profiles, plus Marketplace subscribe
  permissions for auto-activation. Pre-configured model list with
  `us.` inference profile IDs (workaround for OpenClaw bug #5290).
- **Anthropic API**: API key in Secrets Manager, read at boot
- **OpenAI API**: API key in Secrets Manager, read at boot
- **Ollama**: Installed from official tarball, optional model
  pre-pull. Always available for local inference.

### Persistence
- EFS file system mounted at instance boot
- OpenClaw config and operational data persist across instance
  replacement
- Deep-merge strategy: Terraform manages infrastructure config
  (auth, networking, providers), operational settings (Telegram,
  channels, agent tweaks) persist from EFS

### Secrets
- Secrets Manager secret (KMS-encrypted) for LLM API keys
- Instance reads secret at boot via `ih-secrets`
- Environment file written with API keys + AWS region + AWS_PROFILE

### Compute
- Single-instance ASG (stateful application)
- cloud-init bootstraps: packages, user creation, npm install,
  config write, Ollama install, CloudWatch agent, systemd services
- Setup script in Python (templatefile-rendered)
- Systemd hardening: ProtectHome=tmpfs, BindPaths, NoNewPrivileges

### Monitoring
- CloudWatch log group with 365-day retention (ISO27001/SOC2)
- Journald forwarding for openclaw and ollama services
- CloudWatch alarms for ALB health, latency, 5xx errors

### Cognito User Management
- Pre-created users with email invitations
- Optional MFA and advanced security features

---

## Architecture Diagram

```
                    ┌──────────────┐
                    │   Route53    │
                    │  A record(s) │
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
                    │     ALB      │
                    │  (public)    │
                    │  HTTPS:443   │
                    │  ┌────────┐  │
                    │  │Cognito │  │
                    │  │  Auth  │  │
                    │  └────────┘  │
                    └──────┬───────┘
                           │ x-amzn-oidc-identity
                    ┌──────▼───────┐
                    │   OpenClaw   │
                    │  (private)   │
                    │  :5173       │
                    │  ┌────────┐  │
                    │  │ Ollama │  │
                    │  │:11434  │  │
                    │  └────────┘  │
                    └──┬───┬───┬──┘
                       │   │   │
              ┌────────┘   │   └────────┐
              ▼            ▼            ▼
        ┌──────────┐ ┌──────────┐ ┌──────────┐
        │ Bedrock  │ │Anthropic │ │  OpenAI  │
        │ (IAM)    │ │  (key)   │ │  (key)   │
        └──────────┘ └──────────┘ └──────────┘

        ┌──────────┐ ┌──────────┐ ┌──────────┐
        │   EFS    │ │ Secrets  │ │CloudWatch│
        │  config  │ │ Manager  │ │   Logs   │
        └──────────┘ └──────────┘ └──────────┘
```

---

## Config Management Flow

```
Terraform apply
    │
    ▼
openclaw.json (Terraform-managed keys)
    │
    ▼
Instance boot → setup-openclaw.py
    │
    ├─ EFS config exists?
    │   ├─ YES: deep_merge(efs_config, terraform_config)
    │   │       Terraform wins for infrastructure keys
    │   │       EFS preserves operational settings
    │   └─ NO:  Write terraform_config as initial config
    │
    ▼
OpenClaw starts with merged config
    │
    ▼
User changes via UI/CLI → saved to EFS
    │
    ▼
Next instance replacement → merge preserves user changes
```

---

## Module Inputs (Draft)

```hcl
variable "environment" {
  type        = string
  description = "Environment name (e.g. production, development)."
}

variable "zone_id" {
  type        = string
  description = "Route53 hosted zone ID for DNS and certificate."
}

variable "alb_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for the ALB (minimum 2 AZs)."
}

variable "backend_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for the EC2 instance."
}

variable "cognito_users" {
  type = list(object({
    email     = string
    full_name = string
  }))
  description = "Cognito users to create with email invitations."
}

variable "alarm_emails" {
  type        = list(string)
  description = "Email addresses for CloudWatch alarm notifications."
}

variable "enable_bedrock" {
  type        = bool
  description = "Enable AWS Bedrock as an LLM provider."
  default     = true
}

variable "extra_bedrock_models" {
  type = list(object({
    id            = string
    name          = optional(string)
    reasoning     = optional(bool, false)
    input         = optional(list(string), ["text"])
    contextWindow = optional(number, 128000)
    maxTokens     = optional(number, 8192)
  }))
  description = <<-EOT
    Additional Bedrock models with us. inference profile prefix.
    Common Claude and Nova models are included by default.
  EOT
  default = []
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type. Size based on Ollama model needs."
  default     = "t3.large"
}

variable "ollama_default_model" {
  type        = string
  description = "Ollama model to pre-pull. Set to null to skip."
  default     = "qwen2.5:1.5b"
}

variable "extra_packages" {
  type        = list(string)
  description = "Additional APT packages to install."
  default     = []
}

variable "dns_a_records" {
  type        = list(string)
  description = "A record names in the zone for the ALB."
  default     = ["openclaw"]
}

variable "service_name" {
  type        = string
  description = "Service name for resource naming and tags."
  default     = "openclaw"
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the ALB (Cognito protects the app)."
  default     = ["0.0.0.0/0"]
}

variable "root_volume_size" {
  type        = number
  description = "Root EBS volume size in GB."
  default     = 30
}
```

---

## Module Outputs (Draft)

```hcl
output "url"                       { description = "OpenClaw dashboard URL" }
output "alb_dns_name"              { description = "ALB DNS name" }
output "alb_arn"                   { description = "ALB ARN" }
output "asg_name"                  { description = "ASG name" }
output "cognito_user_pool_id"      { description = "Cognito user pool ID" }
output "secret_arn"                { description = "API keys secret ARN" }
output "instance_role_name"        { description = "Instance IAM role name" }
output "backend_security_group_id" { description = "Backend security group ID" }
output "efs_file_system_id"        { description = "EFS file system ID" }
output "cloudwatch_log_group_name" { description = "CloudWatch log group name" }
```

---

## Bedrock Setup Sequence

Users will encounter these errors in order on first deploy. Each
requires a one-time fix:

1. **Marketplace subscription** — AWS auto-subscribes on first
   invocation, but needs `aws-marketplace:Subscribe` permission
   (included in module). Admin may need to trigger subscription
   from the Bedrock console for some providers.

2. **Anthropic use case form** — One-time per account. Open Bedrock
   console > Model catalog > any Claude model > fill form.

3. **Inference profile prefix** — Module pre-configures common
   models with `us.` prefix. Additional models need `us.` prefix
   via `extra_bedrock_models` variable.

---

## Instance Sizing for Ollama

| Ollama model | Params | RAM needed | Instance type | Monthly cost |
|-------------|--------|-----------|--------------|-------------|
| qwen2.5:1.5b | 1-3B | 2-4 GB | t3.large (8 GB) | ~$60 |
| llama3.1:8b | 7-8B | 5-8 GB | t3.xlarge (16 GB) | ~$121 |
| qwen2.5:14b | 13-14B | 10-16 GB | r6i.xlarge (32 GB) | ~$181 |
| codellama:34b | 30-34B | 20-36 GB | r6i.2xlarge (64 GB) | ~$363 |
| llama3.1:70b | 70B | 40-48 GB | r6i.4xlarge (128 GB) | ~$725 |

Default t3.large is sufficient for cloud LLM providers + small local
model for experimentation.

---

## Dependencies

### InfraHouse Modules (registry.infrahouse.com)
- `infrahouse/website-pod/aws` — ALB, ASG, ACM certificate
- `infrahouse/cloud-init/aws` — Cloud-init userdata assembly
- `infrahouse/secret/aws` — KMS-encrypted Secrets Manager secret

### AMI
- InfraHouse Pro AMI (Ubuntu Noble) with CloudWatch agent
- `infrahouse-toolkit` installed via cloud-init packages

### External
- OpenClaw npm package (`@mariozechner/pi-coding-agent`)
- Ollama binary tarball from ollama.com
- Node.js from NodeSource APT repository

---

## Project Items (Todo)

### Repository Setup
1. Create `terraform-aws-openclaw` repo in github-control
2. Add to registry-clients.tf in aws-control-493370826424
3. Set up CI/CD (terraform-CI.yml, terraform-CD.yml)

### Module Extraction
4. Copy module files from modules/openclaw/ to new repo root
5. Add proper provider version constraints
6. Add `created_by_module` tags to resources
7. Generate terraform-docs output in README.md

### Documentation
8. README.md with badges, quick start, full examples
9. FAQ.md (port from current module)
10. docs/ directory for GitHub Pages (index, getting-started,
    configuration, architecture, troubleshooting)
11. examples/ directory (basic, production, custom-models)

### Testing
12. Test root module with terraform.tfvars
13. Integration tests with pytest-infrahouse
14. Test both AWS provider v5 and v6

### Repository Files
15. LICENSE (Apache 2.0)
16. CHANGELOG.md (git-cliff)
17. CONTRIBUTING.md, SECURITY.md
18. mkdocs.yml, .terraform-docs.yml

### CI/CD Role
19. Add GitHub OIDC role permissions in aws-control-493370826424
    (Bedrock, Cognito, EFS, EC2, ALB, Route53, Secrets Manager,
    CloudWatch, Marketplace)