# terraform-aws-percona-server

Terraform module for Percona Server replica set with GTID replication, Orchestrator HA, and automated failover.

GitHub Project: https://github.com/orgs/infrahouse/projects/7

---

## Requirements Summary

### Infrastructure
- Single ASG, odd number of instances (minimum 3)
- ASG health check type: ELB (uses NLB target group health)
- NLB with separate write/read target groups
- DynamoDB table for locks and topology
- S3 bucket for backups and binlogs

### Database
- Percona Server with GTID replication
- One master, N replicas

### Orchestrator
- Sidecar on each node
- Raft cluster with SQLite backend
- Post-failover hooks:
    - Update NLB target groups
    - Update scale-in protection
    - Update DynamoDB topology record

### Provisioning
- Puppet configures Percona and Orchestrator
- Puppet registers instances with appropriate NLB target group
- Custom facts provide cluster_id, dynamodb_table, s3_bucket

### Bootstrap (Master Election)
- Instance acquires DynamoDB lock (`lock-{cluster_id}`)
- Reads topology record (`topology-{cluster_id}`)
- If no master: become master, write topology, take full backup, release lock
- If master exists: restore from backup, configure as replica, release lock
- Uses existing DynamoDB lock class: https://github.com/infrahouse/infrahouse-core/blob/main/src/infrahouse_core/aws/dynamodb.py#L15

### Backups
- Tool: XtraBackup
- Schedule: Weekly full + daily incremental, 00:{random_minute} UTC
- Source: One replica (lock-based election via `backup-lock-{cluster_id}`)
- Destination: S3
- Retention: Configurable, default 4 weeks
- Instance size: Up to 5TB (expect 4-6 hours for full backup/restore)

### Binlog Archival
- Real-time streaming via mysqlbinlog
- One replica holds `binlog-lock-{cluster_id}`
- Position tracked in DynamoDB (`binlog-position-{cluster_id}`)
- GTID-based tracking for minimal data loss
- Synced to S3 continuously

### Health & Replacement
- NLB health check detects dead Percona (port 3306)
- ASG uses NLB health status to trigger instance replacement
- Puppet on new instance handles re-registration

### Target Group Registration

| Event | Who Handles | Action |
|-------|-------------|--------|
| Initial master boot | Puppet | Register to write TG |
| Initial replica boot | Puppet | Register to read TG |
| Master dies (failover) | Orchestrator hook | Deregister old master from write TG, register new master to write TG |
| Replica dies (replacement) | Puppet on new instance | Register to read TG |

### DynamoDB Keys

| Key | Purpose |
|-----|---------|
| `lock-{cluster_id}` | Master election lock |
| `topology-{cluster_id}` | Master info (instance_id, private_ip) |
| `backup-lock-{cluster_id}` | Backup leader election |
| `binlog-lock-{cluster_id}` | Binlog streaming leader election |
| `binlog-position-{cluster_id}` | Last synced GTID position |

---

## Project Items (Todo)

### Infrastructure
1. ASG configuration - single ASG, odd number validation, ELB health check type
2. NLB with separate write/read target groups
3. DynamoDB table for locks and topology
4. S3 bucket for backups and binlogs

### Percona Server
5. Install Percona repository via Puppet
6. Configure Percona Server with GTID replication
7. Master election bootstrap logic with DynamoDB lock
8. Scale-in protection for master instance

### Orchestrator
9. Orchestrator sidecar deployment (Raft + SQLite)
10. Post-failover hook: Update NLB target groups
11. Post-failover hook: Update scale-in protection
12. Post-failover hook: Update DynamoDB topology record

### Backups
13. XtraBackup installation and configuration
14. Weekly full backup with lock-based leader election
15. Daily incremental backup
16. S3 backup storage with configurable retention (default 4 weeks)
17. Bootstrap backup from master (held until complete)

### Binlog Archival
18. Real-time binlog streaming setup (mysqlbinlog)
19. Binlog streaming leader election with lock
20. GTID position tracking in DynamoDB
21. S3 binlog sync

### Puppet Integration
22. Custom facts for cluster_id, dynamodb_table, s3_bucket
23. NLB target group registration logic
24. Percona Server configuration management
25. Orchestrator configuration management

---

## Module Inputs (Draft)

```hcl
variable "cluster_id" {
  description = "Unique identifier for the Percona cluster"
  type        = string
}

variable "instance_count" {
  description = "Number of instances (must be odd, minimum 3)"
  type        = number
  default     = 3

  validation {
    condition     = var.instance_count >= 3 && var.instance_count % 2 == 1
    error_message = "Instance count must be an odd number >= 3"
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the ASG"
  type        = list(string)
}

variable "backup_retention_weeks" {
  description = "Number of weeks to retain backups"
  type        = number
  default     = 4
}

variable "percona_version" {
  description = "Percona Server version (e.g., ps80, ps57)"
  type        = string
  default     = "ps80"
}
```

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                     Single ASG                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   Percona   │  │   Percona   │  │   Percona   │     │
│  │   Master    │  │   Replica   │  │   Replica   │     │
│  │ (protected) │  │             │  │             │     │
│  │ Orchestrator│  │ Orchestrator│  │ Orchestrator│     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
         │                                    │
         │ write TG                          │ read TG
         ▼                                    ▼
┌─────────────────────────────────────────────────────────┐
│                         NLB                             │
│    db-write.internal          db-read.internal          │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                      DynamoDB                           │
│  lock-{cluster_id}         topology-{cluster_id}        │
│  backup-lock-{cluster_id}  binlog-lock-{cluster_id}     │
│  binlog-position-{cluster_id}                           │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                         S3                              │
│  s3://{bucket}/{cluster_id}/full/{timestamp}/           │
│  s3://{bucket}/{cluster_id}/incremental/{timestamp}/    │
│  s3://{bucket}/{cluster_id}/binlogs/                    │
└─────────────────────────────────────────────────────────┘
```

---

## Failover Flow

1. Master dies
2. NLB health check fails, stops sending traffic to master
3. ASG marks instance unhealthy (ELB health check type)
4. Orchestrator (on replicas) detects master failure
5. Orchestrator raft consensus elects new master
6. Orchestrator post-failover hook:
    - Deregisters old master from write TG
    - Registers new master to write TG
    - Removes scale-in protection from old master
    - Adds scale-in protection to new master
    - Updates DynamoDB topology record
7. ASG terminates old master, launches replacement
8. New instance boots, runs Puppet
9. Puppet reads topology from DynamoDB, configures as replica
10. Puppet registers with read TG

---

## Bootstrap Flow (First Cluster Creation)

1. ASG launches 3 instances simultaneously
2. Each instance runs Puppet
3. Each tries to acquire `lock-{cluster_id}`
4. Winner:
    - Reads `topology-{cluster_id}` - not found
    - Configures self as master
    - Writes topology record (instance_id, private_ip)
    - Takes full XtraBackup to S3
    - Releases lock
    - Registers with write TG
    - Sets scale-in protection on self
5. Losers (one at a time):
    - Acquire lock
    - Read topology - found master
    - Restore from S3 backup
    - Configure as replica with `MASTER_AUTO_POSITION=1`
    - Release lock
    - Register with read TG
