resource "aws_instance" "web_1" {
  ami                    = "ami-0320f10e7326a3e68"  # Nova AMI do Amazon Linux 2023
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "key"

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y git nodejs npm postgresql15

    # Clonar o repositório da aplicação
    cd /home/ec2-user
    git clone https://github.com/DanielMelo1/e-commerce-application.git
    cd e-commerce-application/backend

    # Criar o .env dinâmico com o endpoint atualizado do RDS
    echo "DB_USER=postgres
    DB_HOST=${aws_db_instance.rds_postgres.endpoint}
    DB_NAME=empresa_x_rds
    DB_PASSWORD=*Usalg5627#
    DB_PORT=5432
    PORT=3001
    DB_SSL=true" > .env

    # Instalar dependências
    npm install

    # Executar migrações do banco de dados
    npx knex migrate:latest

    # Iniciar backend
    npm run dev &

    # Configurar e iniciar frontend
    cd ../frontend
    npm install
    npm run build
    npm install -g serve
    serve -s dist -l 5173 &
  EOF

  tags = {
    Name = "empresa-x-web-1"
  }
}

resource "aws_instance" "web_2" {
  ami                    = "ami-0320f10e7326a3e68"  # Nova AMI do Amazon Linux 2023
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public_2.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "key"

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y git nodejs npm postgresql15

    cd /home/ec2-user
    git clone https://github.com/DanielMelo1/e-commerce-application.git
    cd e-commerce-application/backend

    echo "DB_USER=postgres
    DB_HOST=${aws_db_instance.rds_postgres.endpoint}
    DB_NAME=empresa_x_rds
    DB_PASSWORD=*Usalg5627#
    DB_PORT=5432
    PORT=3001
    DB_SSL=true" > .env

    npm install
    npx knex migrate:latest
    npm run dev &

    cd ../frontend
    npm install
    npm run build
    npm install -g serve
    serve -s dist -l 5173 &
  EOF

  tags = {
    Name = "empresa-x-web-2"
  }
}
