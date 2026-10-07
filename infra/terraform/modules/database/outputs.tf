output "endpoint" {
  description = "Private database hostname and port."
  value       = aws_db_instance.database.endpoint
}

output "master_secret_arn" {
  description = "ARN for the RDS-managed master password in Secrets Manager."
  value       = aws_db_instance.database.master_user_secret[0].secret_arn
}

output "engine_version" {
  description = "Selected MySQL 8.4 engine version."
  value       = aws_db_instance.database.engine_version
}
