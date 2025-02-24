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

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y git nodejs npm postgresql15

    # Clonar o repositório correto
    cd /home/ec2-user
    git clone https://github.com/DanielMelo1/e-commerce-application.git
    cd e-commerce-application/backend

    # Iniciar backend
    npm install
    npm run dev &

    # Iniciar frontend
    cd ../frontend
    npm install
    npm run build
    npm install -g serve
    serve -s dist -l 80 &
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

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y git nodejs npm postgresql15

    # Clonar o repositório correto
    cd /home/ec2-user
    git clone https://github.com/DanielMelo1/e-commerce-application.git
    cd e-commerce-application/backend

    # Iniciar backend
    npm install
    npm run dev &

    # Iniciar frontend
    cd ../frontend
    npm install
    npm run build
    npm install -g serve
    serve -s dist -l 80 &
  EOF

  tags = {
    Name = "empresa-x-web-2"
  }
}

# Criar Volume EBS para Web 1
resource "aws_ebs_volume" "web1_ebs" {
  availability_zone = "us-east-1a"
  size             = 10

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
  size             = 10

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

# Criar Security Group para o Load Balancer
resource "aws_security_group" "elb_sg" {
  name        = "empresa-x-elb-sg"
  description = "Permitir tráfego para o Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "empresa-x-elb-sg"
  }
}

# Criar Load Balancer
resource "aws_lb" "app_lb" {
  name               = "empresa-x-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets           = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "empresa-x-lb"
  }
}

# Criar Target Group para associar as instâncias EC2 ao Load Balancer
resource "aws_lb_target_group" "app_tg" {
  name     = "empresa-x-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  tags = {
    Name = "empresa-x-target-group"
  }
}

# Registrar instâncias EC2 no Target Group
resource "aws_lb_target_group_attachment" "web1_attach" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.web_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web2_attach" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.web_2.id
  port             = 80
}

# Criar Listener do Load Balancer para redirecionar tráfego para as instâncias
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
