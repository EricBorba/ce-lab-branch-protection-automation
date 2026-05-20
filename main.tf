terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "app_assets" {
  bucket = "${var.project_name}-${var.environment}-assets"

  tags = {
    Name        = "${var.project_name}-assets"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "app_assets" {
  bucket = aws_s3_bucket.app_assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "app_state" {
  name         = "${var.project_name}-${var.environment}-state"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-state"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
