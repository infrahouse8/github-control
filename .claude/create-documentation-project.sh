#!/bin/bash
# Script to create GitHub Project for Terraform Module Documentation Initiative
# Run this script from a terminal with gh CLI installed and authenticated

set -ex

ORG="infrahouse"
PROJECT_TITLE="Terraform Module Documentation Initiative"
PROJECT_DESC="Track documentation completion for all InfraHouse Terraform modules"

echo "Creating GitHub Project..."
PROJECT_DATA=$(gh project create \
  --owner "$ORG" \
  --title "$PROJECT_TITLE" \
  --format json)

PROJECT_URL=$(echo "$PROJECT_DATA" | jq -r '.url')
PROJECT_NUMBER=$(echo "$PROJECT_DATA" | jq -r '.number')

echo "✅ Project created: $PROJECT_URL"
echo "Project Number: $PROJECT_NUMBER"

echo ""
echo "Creating custom fields..."

# Create Tier field
gh project field-create "$PROJECT_NUMBER" \
  --owner "$ORG" \
  --name "Tier" \
  --data-type "SINGLE_SELECT" \
  --single-select-options "Tier 1,Tier 2,Tier 3"

# Create completion tracking fields
gh project field-create "$PROJECT_NUMBER" \
  --owner "$ORG" \
  --name "README Updated" \
  --data-type "SINGLE_SELECT" \
  --single-select-options "✅ Done,❌ Not Done,🚧 In Progress"

gh project field-create "$PROJECT_NUMBER" \
  --owner "$ORG" \
  --name "Docs Pages" \
  --data-type "SINGLE_SELECT" \
  --single-select-options "✅ Done,❌ Not Done,🚧 In Progress"

gh project field-create "$PROJECT_NUMBER" \
  --owner "$ORG" \
  --name "Repository Files" \
  --data-type "SINGLE_SELECT" \
  --single-select-options "✅ Done,❌ Not Done,🚧 In Progress"

gh project field-create "$PROJECT_NUMBER" \
  --owner "$ORG" \
  --name "Release Workflow" \
  --data-type "SINGLE_SELECT" \
  --single-select-options "✅ Done,❌ Not Done,🚧 In Progress"

gh project field-create "$PROJECT_NUMBER" \
  --owner "$ORG" \
  --name "GitHub Settings" \
  --data-type "SINGLE_SELECT" \
  --single-select-options "✅ Done,❌ Not Done,🚧 In Progress"

echo "✅ Custom fields created"

echo ""
echo "Adding automation tasks..."

# Create issues in infrahouse8/github-control repo and add to project
CONTROL_REPO="infrahouse8/github-control"

echo "  Creating automation task issues..."
ISSUE1=$(gh issue create --repo "$CONTROL_REPO" \
  --title "🤖 Deploy release.yml workflow to all terraform_module repos" \
  --body "Automate deployment of .github/workflows/release.yml to all modules" \
  | grep -oP 'https://[^\s]+')

ISSUE2=$(gh issue create --repo "$CONTROL_REPO" \
  --title "🤖 Create SECURITY.md template" \
  --body "Create template file in modules/plain-repo/files/SECURITY.md" \
  | grep -oP 'https://[^\s]+')

ISSUE3=$(gh issue create --repo "$CONTROL_REPO" \
  --title "🤖 Create CONTRIBUTING.md template" \
  --body "Create template file in modules/plain-repo/files/CONTRIBUTING.md" \
  | grep -oP 'https://[^\s]+')

ISSUE4=$(gh issue create --repo "$CONTROL_REPO" \
  --title "🤖 Create README badge template" \
  --body "Create README_TEMPLATE.md with badge placeholders" \
  | grep -oP 'https://[^\s]+')

echo "  Adding issues to project..."
gh project item-add "$PROJECT_NUMBER" --owner "$ORG" --url "$ISSUE1"
gh project item-add "$PROJECT_NUMBER" --owner "$ORG" --url "$ISSUE2"
gh project item-add "$PROJECT_NUMBER" --owner "$ORG" --url "$ISSUE3"
gh project item-add "$PROJECT_NUMBER" --owner "$ORG" --url "$ISSUE4"

echo "✅ Automation tasks added"

echo ""
echo "Adding Tier 1 modules (high priority)..."

# Tier 1: Most important/commonly used modules
TIER1_MODULES=(
  "terraform-aws-actions-runner:Module that deploys self-hosted GitHub Actions runner."
  "terraform-aws-ecs:Module that runs service in ECS"
  "terraform-aws-lambda-monitored:Terraform module for deploying AWS Lambda functions with built-in CloudWatch monitoring"
  "terraform-aws-website-pod:Module that creates an autoscaling group with an ALB and SSL certificate for a website."
  "terraform-aws-key:Module that creates an encryption key in KMS."
  "terraform-aws-s3-bucket:Terraform module for an ISO27001 compliant S3 bucket."
  "terraform-aws-secret:Terraform module for a secret with owner/writer/reader roles."
  "terraform-aws-github-role:Module that creates a role for a GitHub Action worker."
  "terraform-aws-instance-profile:Module bundles AWS resources to create an instance profile."
  "terraform-aws-state-bucket:Module that creates an S3 bucket for a Terraform state."
)

for item in "${TIER1_MODULES[@]}"; do
  IFS=':' read -r name desc <<< "$item"
  echo "  Adding $name..."
  # Create draft items using GraphQL API
  gh api graphql -f query='
    mutation($projectId: ID!, $title: String!) {
      addProjectV2DraftIssue(input: {projectId: $projectId, title: $title}) {
        projectItem {
          id
        }
      }
    }' -f projectId="$(gh api graphql -f query='query($org: String!, $number: Int!) { organization(login: $org) { projectV2(number: $number) { id } } }' -f org="$ORG" -F number="$PROJECT_NUMBER" --jq '.data.organization.projectV2.id')" -f title="$name" > /dev/null
done

echo "✅ Tier 1 modules added"

echo ""
echo "Adding Tier 2 modules (medium priority)..."

# Tier 2: Important but not critical path
TIER2_MODULES=(
  "terraform-aws-aerospike:Module that deploys Aerospike cluster."
  "terraform-aws-bookstack:Module that deploys BookStack."
  "terraform-aws-ci-cd:Module that creates roles, state bucket, and dynamodb table for Terraform CI/CD."
  "terraform-aws-cloudcraft-role:Module that creates a role for CloudCraft scanner."
  "terraform-aws-cloud-init:Module that creates a cloud init configuration for an InfraHouse EC2 instance."
  "terraform-aws-cost-alert:Module that creates a alert for AWS cost per period."
  "terraform-aws-ecr:Module that creates a container registry (AWS ECR service)."
  "terraform-aws-elasticsearch:Module that deploys an Elasticsearch cluster"
  "terraform-aws-kibana:Module that deploys Kibana"
  "terraform-aws-gh-identity-provider:Module that configures GitHub OpenID connector."
  "terraform-aws-gha-admin:Module for two roles to manage AWS with GitHub actions."
  "terraform-aws-github-backup:Module to provision infrahouse-github-backup GitHub App."
  "terraform-aws-github-backup-configuration:Module that configures infrahouse-github-backup GitHub App client."
  "terraform-aws-guardduty-configuration:Module that configures GuardDuty and email notifications."
  "terraform-aws-iso27001:Module configures ISO 27001 compliance for AWS."
  "terraform-aws-jumphost:Module that creates a jumphost."
  "terraform-aws-openvpn:Terraform module that deploys OpenVPN server."
  "terraform-aws-pmm-ecs:Terraform module for deploying Percona Monitoring and Management (PMM) server"
  "terraform-aws-pypiserver:Terraform module that deploys a private PyPI server."
  "terraform-aws-registry:Terraform module that deploys a private Terraform registry."
  "terraform-aws-secret-policy:Terraform module that creates AWS secret permissions policy."
  "terraform-aws-service-network:Terraform service network module."
  "terraform-aws-sqs-pod:Terraform module deploys an SQS queue with autoscaling group as a consumer."
  "terraform-aws-sqs-ecs:Terraform module deploys an SQS queue with ECS service as a consumer."
  "terraform-aws-state-manager:Module creates an IAM role that can manage a Terraform state."
  "terraform-aws-tcp-pod:Module that creates an autoscaling group with an NLB for a TCP based services."
  "terraform-aws-teleport:Module deploys a single node Teleport cluster."
  "terraform-aws-terraformer:Module that deploys an instances allowed to manage Terraform root modules."
  "terraform-aws-update-dns:Module creates a lambda that manages DNS A records for instances in an autoscaling group."
)

for item in "${TIER2_MODULES[@]}"; do
  IFS=':' read -r name desc <<< "$item"
  echo "  Adding $name..."
  # Create draft items using GraphQL API
  gh api graphql -f query='
    mutation($projectId: ID!, $title: String!) {
      addProjectV2DraftIssue(input: {projectId: $projectId, title: $title}) {
        projectItem {
          id
        }
      }
    }' -f projectId="$(gh api graphql -f query='query($org: String!, $number: Int!) { organization(login: $org) { projectV2(number: $number) { id } } }' -f org="$ORG" -F number="$PROJECT_NUMBER" --jq '.data.organization.projectV2.id')" -f title="$name" > /dev/null
done

echo "✅ Tier 2 modules added"

echo ""
echo "Adding Tier 3 modules (lower priority)..."

# Tier 3: Less commonly used or specialized
TIER3_MODULES=(
  "terraform-aws-debian-repo:Module that creates a Debian repository backed by S3 and fronted by CloudFront."
  "terraform-aws-dms:Module for deploying AWS Data Migration Service"
  "terraform-aws-emrserverless:Module for deploying EMR serverless"
  "terraform-aws-http-redirect:Module creates an HTTP redirect server."
  "terraform-aws-postfix:Terraform module that deploys Postfix as a MX server."
  "terraform-aws-tags-override:Module to override tags list for ECS"
  "terraform-aws-teleport-agent:Module deploys roles and other resources on an account joining Teleport cluster."
  "terraform-aws-truststore:Module that creates a trust store with a generated CA certificate."
)

for item in "${TIER3_MODULES[@]}"; do
  IFS=':' read -r name desc <<< "$item"
  echo "  Adding $name..."
  # Create draft items using GraphQL API
  gh api graphql -f query='
    mutation($projectId: ID!, $title: String!) {
      addProjectV2DraftIssue(input: {projectId: $projectId, title: $title}) {
        projectItem {
          id
        }
      }
    }' -f projectId="$(gh api graphql -f query='query($org: String!, $number: Int!) { organization(login: $org) { projectV2(number: $number) { id } } }' -f org="$ORG" -F number="$PROJECT_NUMBER" --jq '.data.organization.projectV2.id')" -f title="$name" > /dev/null
done

echo "✅ Tier 3 modules added"

echo ""
echo "=========================================="
echo "✅ Project setup complete!"
echo "=========================================="
echo ""
echo "Project URL: $PROJECT_URL"
echo ""
echo "Next steps:"
echo "1. Visit the project and review the items"
echo "2. Adjust tier assignments as needed"
echo "3. Start with automation tasks"
echo "4. Begin documenting Tier 1 modules"
echo ""
