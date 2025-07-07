output "python_api_url" {
  value = "http://localhost:8000"
}

output "mysql_port" {
  value = docker_container.mysql.ports[0].external
}

output "nginx_port" {
  value = docker_container.nginx.ports[0].external
}