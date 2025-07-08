# CI/CD Terraform Docker Infrastructure

This project contains Terraform configurations to provision a small Docker-based setup.
It deploys the following resources:

- A Docker network `internal-app-network` used by all containers.
- A MySQL container based on the `mysql:9.2` image.
- A Python API container built from the local `./python-api` context.
- An Nginx container serving traffic on port `8080`.

The Terraform configuration requires Terraform **1.5+** and the following providers:

- `kreuzwerker/docker` (~> 3.0.2)
- `Scalingo/scalingo` (~> 1.0)

## Usage

1. Install Docker and Terraform.
2. Initialize the working directory:
   ```bash
   terraform init
   ```
3. Apply the configuration:
   ```bash
   terraform apply
   ```
   The apply step requires a `SCALINGO_TOKEN` environment variable if you
   plan to use the Scalingo provider.

When complete, Terraform outputs the exposed ports for MySQL, the Python API
and Nginx.

## GitHub Actions

A workflow is provided in `.github/workflows/deploy.yml` to run `terraform init`
and `terraform apply` automatically. It triggers on a `repository_dispatch` event
with the type `deploy`.