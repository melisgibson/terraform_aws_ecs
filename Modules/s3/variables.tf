# ---s3/module/variables.tf---
variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket to create."
}

variable "environment" {}

variable "enable_versioning" {
  type        = bool
  description = "Whether to enable versioning for the S3 bucket."
}

variable "enable_encryption" {
  description = "Enable encryption for the S3 bucket"
}

variable "is_public" {
  description = "Enable public access for the S3 bucket"
  default     = false
}

variable "account_id" {
  
}