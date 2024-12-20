variable "environment" {
  description = "The environment name (e.g., dev, qa, prod)"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
}

variable "task_cpu" {
  description = "CPU units for the ECS task"
  type        = number
}

variable "task_memory" {
  description = "Memory for the ECS task in MiB"
  type        = number
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_image" {
  description = "Container image URI"
  type        = string
}

variable "container_cpu" {
  description = "CPU units for the container"
  type        = number
}

variable "container_memory" {
  description = "Memory for the container in MiB"
  type        = number
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
}

variable "host_port" {
  description = "Port on which the container listens"
  type        = number
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []
}


variable "assign_public_ip" {
  description = "Whether to assign a public IP to ECS tasks"
  type        = bool
}

variable "alb_target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
}

variable "max_task_count" {
  description = "Maximum number of ECS tasks"
  type        = number
}

variable "min_task_count" {
  description = "Minimum number of ECS tasks"
  type        = number
}

variable "db_port" {
  description = "Minimum number of ECS tasks"
  type        = number
}

variable "db_user" {
  description = "The database username"
  type        = string  # Change to string
}

variable "db_password" {
  description = "The database password"
  type        = string  # Change to string
}


variable "db_name" {
  type        = string
  description = "The name of the database"
}

variable "log_group_name" {
  type        = string
  description = "The name of the log group"
}

variable "db_host" {
  type        = string
  description = "The name of the database"
}



