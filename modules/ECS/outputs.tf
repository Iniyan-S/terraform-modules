output "ecs_cluster_id" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.main.id
}

output "ecs_task_definition_arn" {
  description = "ECS Task Definition ARN"
  value       = aws_ecs_task_definition.main.arn
}

output "ecs_service_id" {
  description = "ECS Service ID"
  value       = aws_ecs_service.main.id
}

output "ecs_service_name" {
  description = "ECS Service Name"
  value       = aws_ecs_service.main.name
}

output "log_group_name" {
  value       = var.log_group_name
  description = "CloudWatch Log Group used for ECS tasks"
}


