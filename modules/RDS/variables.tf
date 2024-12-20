# variable "vpc_id" {
#   description = "The VPC ID in which the RDS instance will be created."
#   type        = string
# }

# variable "public_subnet_ids" {
#   description = "List of public subnet IDs for the RDS instance."
#   type        = list(string)
# }

# variable "rds_security_group" {
#   description = "The security group for the RDS instance."
#   type        = string
# }

variable "allocated_storage" {
  description = "The allocated storage size for the RDS instance."
  type        = number
}

variable "max_allocated_storage" {
  description = "The maximum allocated storage for the RDS instance."
  type        = number
}

variable "storage_type" {
  description = "The storage type for the RDS instance."
  type        = string
}

variable "engine" {
  description = "The database engine for the RDS instance."
  type        = string
}

# variable "throughput" {
#   description = "The database engine for the RDS instance."
#   type        = string
# }

variable "engine_version" {
  description = "The version of the database engine."
  type        = string
}

variable "instance_class" {
  description = "The instance class for the RDS instance."
  type        = string
}

# variable "db_name" {
#   description = "The database master username."
#   type        = string
# }

variable "db_user" {
  description = "The database master username."
  type        = string
}

variable "db_password" {
  description = "The database master password."
  type        = string
}

# variable "parameter_group_name" {
#   description = "The DB parameter group name."
#   type        = string
# }

variable "publicly_accessible" {
  description = "Whether the RDS instance is publicly accessible."
  type        = bool
}

variable "multi_az" {
  description = "Whether the RDS instance should be multi-az."
  type        = bool
}

variable "backup_retention_period" {
  description = "The backup retention period for the RDS instance."
  type        = number
}



variable "tags" {
  description = "Tags to apply to the RDS instance."
  type        = map(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs where the RDS instance should be deployed"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the RDS instance"
  type        = string
}

variable "rds_security_group" {
  description = "Security group ID for the RDS instance"
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev, qa, prod)"
  type        = string
}

variable "snapshot_identify" {
  description = "The environment name (e.g., dev, qa, prod)"
  type        = string
}



# variable "iops" {
#   description = "The allocated storage size for the RDS instance."
#   type        = number
# }



