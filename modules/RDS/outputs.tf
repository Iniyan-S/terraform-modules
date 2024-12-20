# output "rds_endpoint" {
#   description = "The connection endpoint for the RDS instance"
#   value       = aws_db_instance.rds_instance.endpoint
# }

output "rds_instance_id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.rds_instance.id
}

output "rds_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.rds_instance.arn
}

# output "vpc_id" {
#   value = var.vpc.vpc_id
# }

# output "security_group_ids" {
#   value = var.vpc_security_group_ids
# }


output "rds_endpoint" {
  value = aws_db_instance.rds_instance.address
  description = "The endpoint address of the RDS instance"
}

output "rds_username" {
  value = aws_db_instance.rds_instance.username
  description = "The username for the RDS instance"
}

# output "dbname" {
#   value = aws_db_instance.rds_instance.username
#   description = "The username for the RDS instance"
# }

output "rds_password" {
  value = aws_db_instance.rds_instance.password
  description = "The password for the RDS instance"
}

# output "db_name" {
#   value = aws_db_instance.rds_instance.db_name
# }



