variable "project_name" {
  description = "Project prefix used in the ECR repository name."
  type        = string
}

variable "environment" {
  description = "Environment suffix used in the ECR repository name."
  type        = string
}

variable "github_repository" {
  description = "GitHub owner/repository allowed to assume the release role."
  type        = string
}

variable "github_branch" {
  description = "Branch allowed to assume the release role."
  type        = string
}
