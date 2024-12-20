# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# output "application_url" {
#   value       = module.alb_client.dns_alb
#   description = "Copy this value in your browser in order to access the deployed app"
# }

# output "swagger_endpoint" {
#   value       = "${module.alb_server.dns_alb}/api/docs"
#   description = "Copy this value in your browser in order to access the swagger documentation"
# }
output "redis_sg_id" {
  description = "The ID of the Redis security group"
  value       = module.redis_sg.sg_id
}

# output "mongodb_sg_id" {
#   description = "The ID of the MongoDB security group"
#   value       = module.mongodb_sg.sg_id
# }

output "rds_sg_id" {
  description = "The ID of the RDS PostgreSQL security group"
  value       = module.rds_security_group.sg_id
}

output "ecs_sg_id" {
  description = "The ID of the ECS security group"
  value       = module.ecs_security_group.sg_id
}

output "alb_sg_id" {
  description = "The ID of the ALB security group"
  value       = module.alb_security_group.sg_id
}

output "ssh_sg_id" {
  description = "The ID of the SSH security group"
  value       = module.ssh_sg.sg_id
}


