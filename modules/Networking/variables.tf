/*==================================================
      AWS VPC Module: Variables
===================================================*/

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_count" {
  description = "The number of public subnets to create"
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "The number of private subnets to create"
  type        = number
  default     = 2
}

variable "subnet_prefix" {
  description = "The prefix to use when calculating subnet CIDR blocks"
  type        = number
  default     = 8
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "The name of the project for tagging resources"
  type        = string
}
