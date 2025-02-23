# Criar um grupo de sub-redes para o RDS (Usando subnets públicas)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "empresa-x-rds-subnet-group"
  description = "Subnets públicas para o RDS"
  subnet_ids  = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    Name = "empresa-x-rds-subnet-group"
  }
}

# Criar a instância RDS PostgreSQL
resource "aws_db_instance" "rds_postgres" {
  identifier             = "empresa-x-rds"
  engine                = "postgres"
  engine_version        = "17"
  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  storage_type          = "gp2"
  username             = "postgres"  # Definição do usuário
  password             = "*Usalg5627#"  # Senha definida pelo usuário
  db_name              = "empresa_x_rds"  # Nome do banco de dados agora definido
  parameter_group_name  = "default.postgres17"
  db_subnet_group_name  = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible   = true  # Banco será acessível externamente
  skip_final_snapshot   = true
  multi_az              = false

  tags = {
    Name = "empresa-x-rds"
    Environment = "Development"
  }
}
