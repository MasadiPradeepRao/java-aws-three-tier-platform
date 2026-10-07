output "repository_url" {
  description = "URL of the immutable-tag ECR image repository."
  value       = aws_ecr_repository.application.repository_url
}

output "repository_arn" {
  description = "ARN of the ECR image repository."
  value       = aws_ecr_repository.application.arn
}

output "github_role_arn" {
  description = "Role ARN for the repository's GitHub Actions workflow."
  value       = aws_iam_role.github_actions.arn
}

output "restart_document_name" {
  description = "SSM document allowed to restart the application service."
  value       = aws_ssm_document.application_restart.name
}
