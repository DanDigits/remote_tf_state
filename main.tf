terraform {
  required_version = "~> 1.5.0"

  # backend "s3" {
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tfState_bucket" {
  bucket = var.bucket_name
  # force_destroy = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_logging" "tfState_logging" {
  bucket = aws_s3_bucket.tfState_bucket.bucket

  target_bucket = aws_s3_bucket.tfState_bucket.id
  target_prefix = "s3_${aws_s3_bucket.tfState_bucket.id}/"
}

resource "aws_s3_bucket_versioning" "tfState_bucket_versioning" {
  bucket = aws_s3_bucket.tfState_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfState_encryption" {
  bucket = aws_s3_bucket.tfState_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfState_private" {
  bucket                  = aws_s3_bucket.tfState_bucket.bucket
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "tfState_ownership_controls" {
  bucket = aws_s3_bucket.tfState_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "tfState_bucket_acl" {
  bucket     = aws_s3_bucket.tfState_bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_public_access_block.tfState_private, aws_s3_bucket_ownership_controls.tfState_ownership_controls]
}

// Dynamodb is needed as a semaphore for locking the S3 bucket when being accessed by others
resource "aws_dynamodb_table" "tfState_locks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}