output "vpc_id" {
  description = "ID of the application VPC."
  value       = module.network.vpc_id
}

output "aws_region" {
  description = "Region used for this stack and the GitHub Actions release workflow."
  value       = var.aws_region
}

output "public_subnet_ids" {
  description = "Public subnet IDs for the load balancer tier."
  value       = module.network.public_subnet_ids
}

output "app_subnet_ids" {
  description = "Private subnet IDs for the application tier."
  value       = module.network.app_subnet_ids
}

output "application_instance_profile_name" {
  description = "Instance profile used by private app and temporary SSM administration instances."
  value       = module.application.instance_profile_name
}

output "application_instance_name" {
  description = "Name tag used by the workflow to select app instances for rollout."
  value       = module.application.instance_name
}

output "data_subnet_ids" {
  description = "Isolated subnet IDs for the database tier."
  value       = module.network.data_subnet_ids
}

output "alb_security_group_id" {
  description = "Security group ID for the internet-facing load balancer."
  value       = module.security.alb_security_group_id
}

output "app_security_group_id" {
  description = "Security group ID for application instances."
  value       = module.security.app_security_group_id
}

output "database_security_group_id" {
  description = "Security group ID for the private database."
  value       = module.security.database_security_group_id
}

output "application_url" {
  description = "Load balancer URL. Use HTTPS only when an ACM certificate was supplied."
  value       = module.application.application_url
}

output "application_target_group_arn" {
  description = "Target group attached to the application Auto Scaling Group."
  value       = module.application.target_group_arn
}

output "database_endpoint" {
  description = "Private RDS endpoint for application configuration."
  value       = module.database.endpoint
}

output "database_hostname" {
  description = "Private RDS hostname without the port."
  value       = module.database.hostname
}

output "database_master_secret_arn" {
  description = "Secrets Manager ARN for the RDS-managed master password; not the password itself."
  value       = module.database.master_secret_arn
}

output "database_application_secret_arn" {
  description = "Empty Secrets Manager secret to populate with the least-privilege application database user."
  value       = module.database.application_secret_arn
}

output "ecr_repository_url" {
  description = "ECR repository URL with immutable commit tags and a mutable latest alias."
  value       = module.release.repository_url
}

output "github_actions_role_arn" {
  description = "AWS role assumed by the trusted GitHub Actions OIDC subject."
  value       = module.release.github_role_arn
}

output "application_restart_document_name" {
  description = "SSM document name used by GitHub Actions for controlled app restarts."
  value       = module.release.restart_document_name
}
