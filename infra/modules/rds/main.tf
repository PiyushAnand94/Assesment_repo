resource "aws_security_group" "rds" {
  name_prefix = "${var.name}-postgres-"
  description = "Allow PostgreSQL connections only from ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from ECS tasks"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ecs_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-postgres-sg"
  }
}

resource "aws_db_subnet_group" "rds" {
  name_prefix = "${var.name}-postgres-"
  description = "Private subnets for ${var.name} PostgreSQL"
  subnet_ids  = var.private_subnet_ids

  tags = {
    Name = "${var.name}-postgres-subnets"
  }
}

resource "aws_db_instance" "postgres" {
  identifier_prefix       = "${var.name}-postgres-"
  engine                  = "postgres"
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  storage_type            = "gp3"
  storage_encrypted       = true
  db_name                 = var.db_name
  username                = var.username
  manage_master_user_password = true
  port                    = 5432
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  publicly_accessible     = false
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.name}-postgres-final"

  tags = {
    Name = "${var.name}-postgres"
  }
}
