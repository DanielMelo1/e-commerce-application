output "rds_endpoint" {
  value = aws_db_instance.rds_postgres.endpoint
  description = "O endpoint do RDS PostgreSQL"
}