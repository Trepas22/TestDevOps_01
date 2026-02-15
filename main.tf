terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  cloud {
    organization = "FPP_DevOps_Testing" # Pon la tuya
    workspaces { name = "TestDevOps_01" }
  }
}

provider "aws" {
  region = "us-east-1" # Región de Virginia (muy barata/gratis)
}

# Creamos un Grupo de Seguridad (el firewall del servidor)
resource "aws_security_group" "allow_web" {
  name        = "permitir_web"
  description = "Permite trafico HTTP"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creamos el servidor real (EC2)
resource "aws_instance" "servidor_devops" {
  ami           = "ami-0c7217cdde317cfec" # Amazon Linux 2 (Free Tier)
  instance_type = "t2.micro"             # El tamaño gratuito
  vpc_security_group_ids = [aws_security_group.allow_web.id]

  # Este script instala Docker y corre tu app al arrancar
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo docker run -d -p 80:3000 trepas22/mi-app-devops:latest
              EOF

  tags = { Name = "MiServidorDevOps" }
}

# Esto nos dirá la dirección web para ver tu app
output "url_publica" {
  value = aws_instance.servidor_devops.public_dns
}