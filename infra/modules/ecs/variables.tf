variable "name" {
  description = "Prefix used to name ECS resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC in which to create the ECS security group"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID of the application load balancer"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ALB target group ARN; its target_type must be ip"
  type        = string
}

variable "container_image" {
  description = "Container image URI, for example an ECR image URI"
  type        = string
}

variable "container_name" {
  description = "Name of the application container in the task definition"
  type        = string
  default     = "app"
}

variable "container_port" {
  description = "Port the application listens on and the ALB forwards to"
  type        = number
  default     = 80
}

variable "task_cpu" {
  description = "Fargate task CPU units"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Fargate task memory in MiB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of tasks to run"
  type        = number
  default     = 1
}

variable "aws_region" {
  description = "AWS region used by the awslogs log driver"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch log retention period"
  type        = number
  default     = 30
}
