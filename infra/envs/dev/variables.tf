variable "environment" {
  description = "Environment name used to distinguish resources"
  type        = string
}

variable "aws_region" {
  description = "AWS region for this environment"
  type        = string
}

variable "container_image" {
  description = "Container image URI for the ECS application"
  type        = string
}

variable "db_username" {
  description = "PostgreSQL master username; RDS stores the generated password in Secrets Manager"
  type        = string
}

variable "db_name" {
  description = "Initial PostgreSQL database name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidr" {
  description = "First public subnet CIDR block"
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "Second public subnet CIDR block"
  type        = string
}

variable "private_subnet_cidr" {
  description = "First private subnet CIDR block"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "Second private subnet CIDR block"
  type        = string
}

variable "ecs_task_cpu" {
  description = "Fargate task CPU units"
  type        = number
}

variable "ecs_task_memory" {
  description = "Fargate task memory in MiB"
  type        = number
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
}

variable "db_instance_class" {
  description = "RDS PostgreSQL instance class"
  type        = string
}

variable "db_allocated_storage" {
  description = "Initial RDS storage in GiB"
  type        = number
}

variable "db_max_allocated_storage" {
  description = "Maximum autoscaled RDS storage in GiB"
  type        = number
}

variable "db_multi_az" {
  description = "Whether to deploy RDS with Multi-AZ standby"
  type        = bool
}

variable "db_backup_retention_days" {
  description = "RDS automated backup retention period in days"
  type        = number
}

variable "db_deletion_protection" {
  description = "Whether RDS deletion protection is enabled"
  type        = bool
}

variable "db_skip_final_snapshot" {
  description = "Whether to skip the final snapshot when RDS is deleted"
  type        = bool
}
