terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "opspulse-dev-tfstate-fc836f"
    key            = "opspulse/dev/backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "opspulse-dev-tflock"
    encrypt        = true
  }

}

provider "aws" {
  region = var.aws_region
}

resource "random_id" "suffix" {
  byte_length = 3
}

locals {
  name_prefix = "${var.project}-${var.environment}"
  suffix      = random_id.suffix.hex

  state_bucket_name = "${local.name_prefix}-tfstate-${local.suffix}"
  lock_table_name   = "${local.name_prefix}-tflock"
  kms_key_alias     = "alias/${local.name_prefix}-tfstate-key"


  common_tags = merge(var.tags, {
    Name = local.name_prefix
  })
}

resource "aws_kms_key" "tfstate" {
  description             = "KMS key for encrypting terraform state in S3"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = local.common_tags
}

resource "aws_kms_alias" "tfstate" {
  name          = local.kms_key_alias
  target_key_id = aws_kms_key.tfstate.key_id
}

resource "aws_s3_bucket" "tfstate" {
  bucket = local.state_bucket_name
  tags   = local.common_tags
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.tfstate.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tflock" {
  name         = local.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  tags         = local.common_tags

  attribute {
    name = "LockID"
    type = "S"
  }
}