/*==================================================
      AWS VPC Module: Outputs
===================================================*/

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "The ID of the created Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "The ID of the created NAT Gateway"
  value       = aws_nat_gateway.main.id
}

# # Output for RDS Security Group ID
# output "rds_security_group_id" {
#   description = "The ID of the RDS security group"
#   value       = aws_security_group.rds_sg.id
# }

# # Output for ECS Service Security Group ID
# output "ecs_service_security_group_id" {
#   description = "The ID of the ECS service security group"
#   value       = aws_security_group.ecs_service_sg.id
# }

output "public_subnet_cidr_blocks" {
  description = "CIDR blocks of public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidr_blocks" {
  description = "CIDR blocks of private subnets"
  value       = aws_subnet.private[*].cidr_block
}
