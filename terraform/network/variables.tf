variable "project" {
  description = "Short Project name used for the naming resources"
  type        = string
  default     = "opspulse"
}

variable "environment" {
  description = "Environment name dev"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "Aws region for the network."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Project     = "OpsPulse"
    Owner       = "Shirish"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}
