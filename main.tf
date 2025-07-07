provider "docker" {}

provider "scalingo" {}  # laissé vide si besoin de gérer d'autres ressources Scalingo plus tard

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

resource "docker_image" "python_api" {
  name = "python-api"
  build {
    context = "./python-api"
  }
  keep_locally = true
}

resource "docker_container" "python_api" {
  name  = "python-api"
  image = docker_image.python_api.image_id
  networks_advanced {
    name = docker_network.internal_network.name
  }
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

resource "docker_image" "nginx" {
  name = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  name = "nginx"
  image = docker_image.nginx.image_id
  ports {
    external = 8080
    internal = 80
  }
}