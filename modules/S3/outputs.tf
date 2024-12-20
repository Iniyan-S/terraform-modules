/*===========================
       Outputs Definition
============================*/

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.s3_bucket.bucket
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.s3_bucket.arn
}

# output "logging_bucket" {
#   description = "The logging bucket used for S3 access logs"
#   value       = var.logging_bucket_name
# }

