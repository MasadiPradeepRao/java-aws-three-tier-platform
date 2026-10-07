variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "enable_https" {
  description = "Whether the ALB will have an HTTPS listener."
  type        = bool
  default     = false
}
