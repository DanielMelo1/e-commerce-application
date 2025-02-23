data "aws_ssm_parameter" "amzn2_latest" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Criar Instância EC2 - Servidor Web 1
resource "aws_instance" "web_1" {
  ami                    = data.aws_ssm_parameter.amzn2_latest.value
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "key"

  # Script de inicialização (User Data) para configurar a EC2 automaticamente
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y git nodejs npm postgresql15

    # Clonar o repositório da aplicação
    cd /home/ec2-user
    git clone https://github.com/DanielMelo1/e-commerce-app.git
    cd ecommerce-app/backend

    # Instalar dependências e iniciar backend
    npm install
    npm run dev &
    
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

# Criar Instância EC2 - Servidor Web 2
resource "aws_instance" "web_2" {
  ami                    = data.aws_ssm_parameter.amzn2_latest.value
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public_2.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "key"

  # Script de inicialização (User Data) para configurar a EC2 automaticamente
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y git nodejs npm postgresql15

    # Clonar o repositório da aplicação
    cd /home/ec2-user
    git clone https://github.com/seu-usuario/ecommerce-app.git
    cd ecommerce-app/backend

    # Instalar dependências e iniciar backend
    npm install
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

# Criar Volume EBS para Web 1
resource "aws_ebs_volume" "web1_ebs" {
  availability_zone = "us-east-1a"
  size             = 10  # Tamanho em GB

  tags = {
    Name = "empresa-x-web-1-ebs"
  }
}

# Anexar o Volume EBS à Instância Web 1
resource "aws_volume_attachment" "web1_attach" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.web1_ebs.id
  instance_id = aws_instance.web_1.id
}

# Criar Volume EBS para Web 2
resource "aws_ebs_volume" "web2_ebs" {
  availability_zone = "us-east-1b"
  size             = 10  # Tamanho em GB

  tags = {
    Name = "empresa-x-web-2-ebs"
  }
}

# Anexar o Volume EBS à Instância Web 2
resource "aws_volume_attachment" "web2_attach" {
  device_name = "/dev/xvdg"
  volume_id   = aws_ebs_volume.web2_ebs.id
  instance_id = aws_instance.web_2.id
}
