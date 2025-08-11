output "cluster_id" {
  description = "The ID/ARN of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.id
}

