output "endpoint" {
  description = "Private DNS endpoint for the PostgreSQL instance"
  value       = aws_db_instance.postgres.address
}

output "port" {
  description = "PostgreSQL listener port"
  value       = aws_db_instance.postgres.port
}

output "database_name" {
  description = "Initial PostgreSQL database name"
  value       = aws_db_instance.postgres.db_name
}

output "security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}

output "master_user_secret_arn" {
  description = "Secrets Manager secret ARN containing the generated master password"
  value       = aws_db_instance.postgres.master_user_secret[0].secret_arn
}
