terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Definimos la imagen que acabas de subir a Docker Hub
resource "docker_image" "mi_app" {
  name         = "trepas22/mi-app-devops:latest"
  keep_locally = false
}

# Definimos el contenedor (el servidor ejecutándose)
resource "docker_container" "servidor_web" {
  image = docker_image.mi_app.image_id
  name  = "mi-servidor-produccion"
  ports {
    internal = 3000
    external = 8080
  }
}

# Este bloque "pregunta" a Docker Hub cuál es el ID más reciente de tu imagen
data "docker_registry_image" "mi_app_info" {
  name = "TU_USUARIO_DOCKER/mi-app-devops:latest"
}

resource "docker_image" "mi_app" {
  name          = data.docker_registry_image.mi_app_info.name
  pull_triggers = [data.docker_registry_image.mi_app_info.sha256_digest] # ¡ESTA ES LA CLAVE!
  keep_locally  = false
}

resource "docker_container" "servidor_web" {
  image = docker_image.mi_app.image_id
  name  = "mi-servidor-produccion"
  ports {
    internal = 3000
    external = 8080
  }
}