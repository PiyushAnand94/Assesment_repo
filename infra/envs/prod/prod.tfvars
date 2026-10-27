environment               = "prod"
aws_region                = "us-east-1"
container_image           = "public.ecr.aws/docker/library/nginx:latest"
db_username               = "appadmin"
db_name                   = "app"

vpc_cidr                  = "10.20.0.0/16"
public_subnet_cidr        = "10.20.1.0/24"
public_subnet_2_cidr      = "10.20.4.0/24"
private_subnet_cidr       = "10.20.2.0/24"
private_subnet_2_cidr     = "10.20.3.0/24"

ecs_task_cpu              = 512
ecs_task_memory           = 1024
ecs_desired_count         = 2
log_retention_days        = 30

db_instance_class         = "db.t3.small"
db_allocated_storage      = 100
db_max_allocated_storage  = 500
db_multi_az               = true
db_backup_retention_days  = 30
db_deletion_protection    = true
db_skip_final_snapshot    = false
