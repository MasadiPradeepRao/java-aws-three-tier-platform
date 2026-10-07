output "vpc_id" {
  description = "ID of the application VPC."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs for the load balancer tier."
  value       = module.network.public_subnet_ids
}

output "app_subnet_ids" {
  description = "Private subnet IDs for the application tier."
  value       = module.network.app_subnet_ids
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
