variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "The availability zones to deploy the subnets"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}