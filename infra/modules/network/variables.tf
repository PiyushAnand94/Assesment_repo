variable "name" {
  description = "Name prefix used for VPC and network resource tags"
  type        = string
  default     = "app"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet in a different Availability Zone"
  type        = string
  default     = "10.0.4.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet in a different Availability Zone"
  type        = string
  default     = "10.0.3.0/24"
}
