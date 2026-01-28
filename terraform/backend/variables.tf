variable "project" {
  description = "short project name used for naming resources."
  type        = string
  default     = "opspulse"
}

variable "environment" {
  description = "Environment name (dev/test/prod). For this project its dev. "
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region where backend resources will be created."
  type        = string
  default     = "us-east-1"

}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default = {
    project     = "Opspulse"
    Owner       = "Shirish"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}
