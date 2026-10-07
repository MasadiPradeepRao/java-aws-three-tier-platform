output "endpoint" {
  description = "Private database hostname and port."
  value       = aws_db_instance.database.endpoint
}

output "hostname" {
  description = "Private database hostname without the port."
  value       = aws_db_instance.database.address
}

output "master_secret_arn" {
  description = "ARN for the RDS-managed master password in Secrets Manager."
  value       = aws_db_instance.database.master_user_secret[0].secret_arn
}

output "engine_version" {
  description = "Selected MySQL 8.4 engine version."
  value       = aws_db_instance.database.engine_version
}

output "application_secret_arn" {
  description = "Secrets Manager ARN for the application database user; Terraform does not store its value."
  value       = aws_secretsmanager_secret.application_database.arn
}

output "identifier" {
  description = "RDS identifier used as the CloudWatch metric dimension."
  value       = aws_db_instance.database.identifier
}
