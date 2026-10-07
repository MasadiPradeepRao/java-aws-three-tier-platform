output "repository_url" {
  description = "URL of the immutable-tag ECR image repository."
  value       = aws_ecr_repository.application.repository_url
}

output "github_role_arn" {
  description = "Role ARN for the repository's GitHub Actions workflow."
  value       = aws_iam_role.github_actions.arn
}
