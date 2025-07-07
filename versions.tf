terraform {
  required_version = ">= 1.5.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
    scalingo = {
      source  = "Scalingo/scalingo"
      version = "~> 1.0"
    }
  }
}