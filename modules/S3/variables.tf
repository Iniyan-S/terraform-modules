/*===========================
     Variables Definition
============================*/

variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  type        = string
}

# variable "logging_bucket_name" {
#   description = "The name of the S3 bucket where logs will be stored"
#   type        = string
# }

variable "environment" {
  description = "The environment for which the S3 bucket is created (e.g., dev, staging, prod)"
  type        = string
  default     = "demo-site"
}
