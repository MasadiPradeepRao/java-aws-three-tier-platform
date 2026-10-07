variable "project_name" {
  description = "Short name used to identify resources created by this project."
  type        = string
  default     = "access-portal"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region for the demonstration environment."
  type        = string
  default     = "eu-north-1"
}

variable "availability_zones" {
  description = "Two Availability Zones used by the three subnet tiers."
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"]

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "This network layout expects exactly two Availability Zones."
  }
}

variable "vpc_cidr" {
  description = "IPv4 CIDR range for the project VPC."
  type        = string
  default     = "10.40.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs for the internet-facing load balancer and NAT gateways."
  type        = list(string)
  default     = ["10.40.0.0/24", "10.40.1.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.availability_zones)
    error_message = "Provide one public subnet CIDR for each Availability Zone."
  }
}

variable "app_subnet_cidrs" {
  description = "Private subnet CIDRs for the application tier."
  type        = list(string)
  default     = ["10.40.10.0/24", "10.40.11.0/24"]

  validation {
    condition     = length(var.app_subnet_cidrs) == length(var.availability_zones)
    error_message = "Provide one application subnet CIDR for each Availability Zone."
  }
}

variable "data_subnet_cidrs" {
  description = "Private subnet CIDRs for the database tier."
  type        = list(string)
  default     = ["10.40.20.0/24", "10.40.21.0/24"]

  validation {
    condition     = length(var.data_subnet_cidrs) == length(var.availability_zones)
    error_message = "Provide one data subnet CIDR for each Availability Zone."
  }
}

variable "nat_gateway_strategy" {
  description = "Use one NAT gateway to reduce demo cost, or one per AZ for AZ-local egress."
  type        = string
  default     = "single"

  validation {
    condition     = contains(["single", "per_az"], var.nat_gateway_strategy)
    error_message = "nat_gateway_strategy must be either single or per_az."
  }
}

variable "acm_certificate_arn" {
  description = "Optional ACM certificate ARN in this AWS Region. When set, HTTP redirects to HTTPS."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition = (var.acm_certificate_arn == null && var.application_domain_name == null) || (
      var.acm_certificate_arn != null && var.application_domain_name != null
    )
    error_message = "Set both acm_certificate_arn and application_domain_name for HTTPS, or leave both unset for the HTTP demo."
  }
}

variable "application_domain_name" {
  description = "DNS name covered by the ACM certificate, such as portal.example.com."
  type        = string
  default     = null
  nullable    = true
}

variable "app_instance_type" {
  description = "EC2 instance type used by the application Auto Scaling Group."
  type        = string
  default     = "t3.micro"
}

variable "app_min_size" {
  description = "Minimum application instance count. Keep at zero until an application image is published."
  type        = number
  default     = 0
}

variable "app_desired_capacity" {
  description = "Desired application instance count. Keep at zero until an application image is published."
  type        = number
  default     = 0
}

variable "app_max_size" {
  description = "Maximum application instance count."
  type        = number
  default     = 2
}

variable "database_instance_class" {
  description = "RDS MySQL instance class. RDS remains billable while running."
  type        = string
  default     = "db.t3.micro"
}

variable "database_master_username" {
  description = "RDS master username. RDS generates and stores its password in Secrets Manager."
  type        = string
  default     = "portal_admin"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_]{0,15}$", var.database_master_username))
    error_message = "The database master username must start with a letter and contain at most 16 letters, digits, or underscores."
  }
}
