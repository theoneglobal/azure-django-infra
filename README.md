# Django on Azure Infrastructure

[![Terraform CI](https://github.com/theoneglobal/azure-django-infra/actions/workflows/terraform.yml/badge.svg)](https://github.com/theoneglobal/azure-django-infra/actions/workflows/terraform.yml)
[![Terraform Version](https://img.shields.io/badge/terraform-%E2%89%A51.5.0-blue)](https://www.terraform.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository contains Terraform configurations to deploy a Django application on Azure, including an App Service, PostgreSQL database, Azure Storage, and a Container Registry for Docker images.

## Overview

The infrastructure includes:
- **Azure Resource Group**: Hosts all resources.
- **App Service Plan**: Configures a Linux-based plan for the Django app.
- **App Service**: Runs the Django application using a Docker image.
- **PostgreSQL Flexible Server**: Managed database for Django.
- **Azure Storage Account**: Stores media and static files.
- **Container Registry**: Stores the Docker image (supports GitHub Container Registry, Docker Hub, or Azure Container Registry).
- **Role Assignment**: Grants the App Service permission to pull images from the Container Registry.

## Prerequisites

- **Terraform**: Version 1.5 or later.
- **Azure CLI**: For authentication and managing Azure resources.
- **Azure Subscription**: With permissions to create resources.
- **Docker Image**: Pushed to a registry (e.g., GitHub Container Registry, Docker Hub, or Azure Container Registry).
- **GitHub Token**: (Optional) For pushing to GitHub Container Registry.

## Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/theoneglobal/azure-django-infra.git
   cd azure-django-infra
   ```

2. **Configure Azure Backend**:
   Copy `backend.tf.example` to `backend.tf` and update with your Azure storage account details:
   ```bash
   cp backend.tf.example backend.tf
   ```
   Edit `backend.tf` to match your Terraform state storage configuration.

3. **Set Up Variables**:
   Create a `terraform.tfvars` file to define variables (or use environment variables):
   ```hcl
   infra_resource_group_name = "my-resource-group"
   project_name              = "myproject"
   environment               = "dev"
   db_server_name            = "mypostgres"
   db_admin_user             = "adminuser"
   db_admin_pass             = "securepassword"
   db_name                   = "mydatabase"
   app_service_name          = "my-django-app"
   docker_registry_server    = "ghcr.io"
   docker_image_name         = "theoneglobal/myapp"
   docker_image_tag          = "latest"
   location                  = "West Europe"
   tags                      = { environment = "dev", project = "myproject" }
   ```
   Alternatively, pass variables via command line or environment variables (e.g., `TF_VAR_db_admin_pass`).

4. **Authenticate with Azure**:
   ```bash
   az login
   ```

5. **Push Docker Image to GitHub Container Registry** (Optional):
   If using GitHub Container Registry:
   - Create a Personal Access Token (PAT) with `write:packages` and `read:packages` scopes.
   - Log in to GitHub Container Registry:
     ```bash
     echo $PAT | docker login ghcr.io -u theoneglobal --password-stdin
     ```
   - Build and push your Docker image:
     ```bash
     docker build -t ghcr.io/theoneglobal/myapp:latest .
     docker push ghcr.io/theoneglobal/myapp:latest
     ```
   - Ensure `docker_registry_server` is set to `ghcr.io` and `docker_image_name` to `theoneglobal/myapp`.

6. **Initialize Terraform**:
   ```bash
   terraform init
   ```

## Terraform Usage

- **Initialize Terraform**:
  Initialize the working directory to download providers and modules:
  ```bash
  terraform init
  ```

- **Format Terraform Files**:
  Ensure consistent formatting:
  ```bash
  terraform fmt -recursive
  ```

- **Validate Configuration**:
  Check for syntax and configuration errors:
  ```bash
  terraform validate
  ```

- **Plan Deployment**:
  Generate an execution plan using a variable file:
  ```bash
  terraform plan -var-file=terraform.tfvars -out=tfplan
  ```
  Or specify variables directly:
  ```bash
  terraform plan -var="infra_resource_group_name=my-resource-group" -var="project_name=myproject" -out=tfplan
  ```

- **Apply Changes**:
  Deploy the infrastructure:
  ```bash
  terraform apply tfplan
  ```
  Or apply with a variable file:
  ```bash
  terraform apply -var-file=terraform.tfvars
  ```

- **Destroy Infrastructure** (Optional):
  Remove all resources:
  ```bash
  terraform destroy -var-file=terraform.tfvars
  ```

## Outputs

After deployment, Terraform outputs:
- `resource_group_name`: Name of the resource group.
- `location`: Azure region.
- `postgresql_server_fqdn`: PostgreSQL server hostname.
- `storage_account_name`: Storage account for media/static files.
- `app_service_url`: URL of the Django web app.

## Using GitHub Container Registry

To use GitHub Container Registry (ghcr.io):
- Set `docker_registry_server = "ghcr.io"` in `terraform.tfvars`.
- Use `docker_image_name = "theoneglobal/<image-name>"` (e.g., `theoneglobal/myapp`).
- Ensure the image is public or accessible via a GitHub PAT for private images.
- The App Service pulls the image without authentication for public images. For private images, configure `docker_registry_username` and `docker_registry_password` in the `site_config` block (not included in the current setup).

## GitHub Actions

A GitHub Action workflow (`.github/workflows/terraform.yml`) validates and plans the Terraform configuration on pull requests and pushes to the `main` branch.

## Dependabot

Dependabot (`.github/dependabot.yml`) monitors and updates GitHub Actions and Terraform provider dependencies weekly.

## Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/my-feature`).
3. Commit changes (`git commit -m "Add my feature"`).
4. Push to the branch (`git push origin feature/my-feature`).
5. Open a pull request.
