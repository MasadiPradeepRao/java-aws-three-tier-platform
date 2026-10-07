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
