output "repository_name" {
  description = "The created repository name."
  value       = github_repository.this.name
}

output "repository_node_id" {
  description = "The GraphQL node ID of the repository."
  value       = github_repository.this.node_id
}
