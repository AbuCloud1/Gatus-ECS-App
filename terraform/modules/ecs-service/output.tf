output "service_id" {
  description = "The ID of the ECS service"
  value       = aws_ecs_service.ecs_service.id
}

output "service_arn" {
  description = "The ARN of the ECS service"
  value       = aws_ecs_service.ecs_service.id
}

output "task_definition_arn" {
  description = "The ARN of the ECS task definition"
  value       = aws_ecs_task_definition.ecs_task_definition.arn
}

output "security_group_id" {
  description = "The ID of the security group for ECS tasks"
  value       = aws_security_group.ecs_tasks.id
}
