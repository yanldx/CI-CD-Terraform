terraform {
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "3.0.2"
        }
    }
}

provider "docker" {
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  name  = "nginx"
  image = docker_image.nginx.image_id
  ports {
    external = 8080
    internal = 80
  }
}

resource "docker_network" "internal_network" {
  name = "internal-app-network"
}

resource "docker_image" "mysql" {
  name = "mysql:9.2"
}

resource "docker_container" "mysql" {
  name  = "mysql"
  image = docker_image.mysql.image_id
  networks_advanced {
    name = docker_network.internal_network.name
  }
  env = ["MYSQL_ROOT_PASSWORD=pwd"]
  ports {
    external = 3306
    internal = 3306
  }
}


resource "docker_image" "python-api" {
  name = "python-api"
  keep_locally = true
  build {
    context    = "./python-api"
  }
}

resource "docker_container" "python-api" {
    name  = "python-api"
    networks_advanced {
        name = docker_network.internal_network.name
    }
    image = docker_image.python-api.image_id
    env = [
        "MYSQL_ROOT_PASSWORD=pwd",
        "MY_SQL_DATABASE=Ynov",
        "MY_SQL_USERNAME=root",
        "PORT=8000",
        "MY_SQL_HOST=${docker_container.mysql.network_data.0.ip_address}"
    ]
    ports {
        external = 8000
        internal = 8000
    }
    restart = "always"
}