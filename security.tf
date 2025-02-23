# Security Group para as instâncias EC2
resource "aws_security_group" "ec2_sg" {
  name        = "empresa-x-ec2-sg"
  description = "Permitir acesso HTTP, HTTPS e SSH para EC2"
  vpc_id      = aws_vpc.main.id

  # HTTP (80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS (443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH (22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ⚠️ Após o teste, restrinja para o seu IP
  }

  # Porta Backend (3001)
  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Porta Frontend (5173)
  ingress {
    from_port   = 5173
    to_port     = 5173
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir saída para qualquer destino
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "empresa-x-ec2-sg"
  }
}

# Security Group para o RDS
resource "aws_security_group" "rds_sg" {
  name        = "empresa-x-rds-sg"
  description = "Permitir acesso ao RDS externamente para testes"
  vpc_id      = aws_vpc.main.id

  # Permitir conexões PostgreSQL na porta 5432 (⚠️ Para testes, está aberto para qualquer IP)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ⚠️ Após testar, restrinja para seu IP ou Security Group específico
  }

  # Permitir saída para qualquer destino
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "empresa-x-rds-sg"
  }
}
