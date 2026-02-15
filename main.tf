terraform {
  cloud {
    organization = "FPP_DevOps_Testing" # La que creaste en el paso anterior

    workspaces {
      name = "TestDevOps_01"
    }
  }

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# 1. Consulta la información más reciente en Docker Hub
data "docker_registry_image" "mi_app_info" {
  name = "trepas22/mi-app-devops:latest"
}

# 2. Define la imagen usando el "trigger" de cambio
resource "docker_image" "mi_app" {
  name          = data.docker_registry_image.mi_app_info.name
  pull_triggers = [data.docker_registry_image.mi_app_info.sha256_digest]
  keep_locally  = false
}

# 3. Define el contenedor
resource "docker_container" "servidor_web" {
  image = docker_image.mi_app.image_id
  name  = "mi-servidor-produccion"
  ports {
    internal = 3000
    external = 8080
  }
}