output "target_group_arn" {
  description = "ARN of the ALB target group for ECS service registration"
  value       = aws_lb_target_group.alb_tg.arn
}

output "target_group_name" {
  description = "Name of the ALB target group"
  value       = aws_lb_target_group.alb_tg.name
}

output "alb_security_group_id" {
  description = "Security group ID attached to the ALB"
  value       = aws_security_group.alb_sg.id
}

output "alb_arn" {
  description = "ARN of the application load balancer"
  value       = aws_lb.app_alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.app_alb.dns_name
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID of the application load balancer"
  value       = aws_lb.app_alb.zone_id
}