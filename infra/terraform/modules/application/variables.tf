variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "app_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "app_security_group_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "ecr_repository_arn" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "database_endpoint" {
  type = string
}

variable "database_secret_arn" {
  type = string
}

variable "certificate_arn" {
  type     = string
  default  = null
  nullable = true
}

variable "domain_name" {
  type     = string
  default  = null
  nullable = true
}

variable "instance_type" {
  type = string
}

variable "min_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "max_size" {
  type = number
}
