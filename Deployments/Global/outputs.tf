# ---Global/outputs.tf---

output "bucket_id" {
  description = "The ID of the S3 bucket."
  value       = module.s3.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = module.s3.bucket_arn
}