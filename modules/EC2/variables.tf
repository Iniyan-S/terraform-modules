variable "instance_name" {
  description = "Name of the EC2 instance"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  description = "Instance type"
}

variable "key_name" {
  description = "Key pair name for SSH access"
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be created"
}

variable "user_data" {
  description = "User data script for initialization"
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the EC2 instance"
  type        = list(string)
}

