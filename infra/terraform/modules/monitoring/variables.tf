variable "project_name" {
  description = "Project identifier used in resource names."
  type        = string
}

variable "environment" {
  description = "Environment identifier used in resource names."
  type        = string
}

variable "alert_email" {
  description = "Optional email address for alarm and budget notifications."
  type        = string
  default     = null
  nullable    = true
}

variable "monthly_budget_limit_usd" {
  description = "Monthly cost notification threshold in USD."
  type        = number
}

variable "load_balancer_arn_suffix" {
  description = "Load balancer ARN suffix for CloudWatch metrics."
  type        = string
}

variable "target_group_arn_suffix" {
  description = "Target group ARN suffix for CloudWatch metrics."
  type        = string
}

variable "database_identifier" {
  description = "RDS instance identifier for CloudWatch metrics."
  type        = string
}
