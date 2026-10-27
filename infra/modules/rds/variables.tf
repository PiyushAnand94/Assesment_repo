variable "name" {
  description = "Prefix used to name RDS resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC in which to create the RDS security group"
  type        = string
}

variable "private_subnet_ids" {
  description = "At least two private subnet IDs in different Availability Zones"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "RDS requires a DB subnet group with subnets in at least two Availability Zones."
  }
}

variable "ecs_security_group_id" {
  description = "ECS task security group allowed to connect to PostgreSQL"
  type        = string
}

variable "username" {
  description = "Master username; the password is generated and managed by RDS in Secrets Manager"
  type        = string
}

variable "db_name" {
  description = "Initial PostgreSQL database name"
  type        = string
  default     = "app"
}

variable "engine_version" {
  description = "PostgreSQL engine version; null selects the AWS default"
  type        = string
  default     = null
  nullable    = true
}

variable "instance_class" {
  description = "RDS DB instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial storage size in GiB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum autoscaled storage in GiB; set to 0 to disable autoscaling"
  type        = number
  default     = 100
}

variable "multi_az" {
  description = "Whether to deploy a standby in another Availability Zone"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Automated backup retention in days"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Whether to prevent accidental deletion of the DB instance"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip the final snapshot when deleting the DB; disabling it retains a final snapshot"
  type        = bool
  default     = false
}
