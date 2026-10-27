module "network" {
  source = "../../modules/network"

  name                  = "app-${var.environment}"
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_cidr   = var.private_subnet_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
}

module "alb" {
  source = "../../modules/alb"

  name              = "app-${var.environment}"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
}

module "ecs" {
  source = "../../modules/ecs"

  name                  = "app-${var.environment}"
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  alb_security_group_id = module.alb.alb_security_group_id
  target_group_arn      = module.alb.target_group_arn
  container_image       = var.container_image
  aws_region            = var.aws_region
  task_cpu              = var.ecs_task_cpu
  task_memory           = var.ecs_task_memory
  desired_count         = var.ecs_desired_count
  log_retention_days    = var.log_retention_days
}

module "rds" {
  source = "../../modules/rds"

  name                    = "app-${var.environment}"
  vpc_id                  = module.network.vpc_id
  private_subnet_ids      = module.network.private_subnet_ids
  ecs_security_group_id   = module.ecs.task_security_group_id
  username                = var.db_username
  db_name                 = var.db_name
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  max_allocated_storage   = var.db_max_allocated_storage
  multi_az                = var.db_multi_az
  backup_retention_period = var.db_backup_retention_days
  deletion_protection     = var.db_deletion_protection
  skip_final_snapshot     = var.db_skip_final_snapshot
}
