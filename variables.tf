variable "bucket_name" {
  description = "Remote S3 bucket name"
  type        = string
  validation {
    condition     = can(regex("^([a-z0-9]{1}[a-z0-9-]{1,61}[a-z0-9]{1})$", var.bucket_name))
    error_message = "Bucket name cannot be empty and must follow S3 naming rules"
  }
}

variable "table_name" {
  description = "Remote DynamoDB table name"
  type        = string
}