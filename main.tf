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

# Buscador dinámico de la imagen más reciente de Amazon Linux 2023
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-kernel-6.1-x86_64"]
  }
}

resource "aws_instance" "servidor_devops" {
  ami           = data.aws_ami.amazon_linux_2023.id # Usa el ID que encontró arriba
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.allow_web.id]

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker
              systemctl start docker
              systemctl enable docker
              docker run -d -p 80:3000 trepas22/mi-app-devops:latest
              EOF

  tags = { Name = "MiServidorDevOps" }
}

output "url_publica" {
  value = "http://${aws_instance.servidor_devops.public_ip}"
}