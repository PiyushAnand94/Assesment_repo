output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.this.name
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.this.name
}

output "task_security_group_id" {
  description = "Security group ID attached to ECS tasks; use as the source for the RDS ingress rule"
  value       = aws_security_group.ecs.id
}
