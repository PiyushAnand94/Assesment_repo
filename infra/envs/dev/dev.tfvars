environment               = "dev"
aws_region                = "us-east-1"
container_image           = "public.ecr.aws/docker/library/nginx:latest"
db_username               = "appadmin"
db_name                   = "app"

vpc_cidr                  = "10.10.0.0/16"
public_subnet_cidr        = "10.10.1.0/24"
public_subnet_2_cidr      = "10.10.4.0/24"
private_subnet_cidr       = "10.10.2.0/24"
private_subnet_2_cidr     = "10.10.3.0/24"

ecs_task_cpu              = 256
ecs_task_memory           = 512
ecs_desired_count         = 1
log_retention_days        = 7

db_instance_class         = "db.t3.micro"
db_allocated_storage      = 20
db_max_allocated_storage  = 50
db_multi_az               = false
db_backup_retention_days  = 1
db_deletion_protection    = false
db_skip_final_snapshot    = true
