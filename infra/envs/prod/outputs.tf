output "alb_dns_name" {
  description = "Public DNS name of the application load balancer"
  value       = module.alb.alb_dns_name
}

output "rds_endpoint" {
  description = "Private PostgreSQL endpoint"
  value       = module.rds.endpoint
}

output "rds_master_user_secret_arn" {
  description = "Secrets Manager ARN containing the generated database master password"
  value       = module.rds.master_user_secret_arn
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}
