variable "name" {
  description = "Name used as the prefix for ALB resources"
  type        = string
  default     = "app"
}

variable "vpc_id" {
  description = "VPC in which to create the ALB security group and target group"
  type = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs attached to the ALB"
  type = list(string)
}

variable "listener_port" {
  description = "Port on which the ALB listener accepts traffic"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol used by the ALB listener"
  type        = string
  default     = "HTTP"
}

variable "target_port" {
  description = "Port on which the application container listens"
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "Protocol used between the ALB and application targets"
  type        = string
  default     = "HTTP"
}

variable "allowed_ingress_cidrs" {
  description = "CIDR ranges allowed to connect to the ALB listener"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "health_check_path" {
  description = "HTTP path used by the target group health check"
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "HTTP response codes treated as healthy"
  type        = string
  default     = "200"
}