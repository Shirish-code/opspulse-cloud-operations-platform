variable "project" {
  description = "Project name for resource naming"
  type        = string
  default     = "opspulse"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Project     = "OpsPulse"
    Owner       = "Shirish"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}
