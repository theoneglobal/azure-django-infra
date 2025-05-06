variable "infra_resource_group_name" {
  description = "Name of the Azure Resource Group for Infrastructure (App Service, Postgres)."
  type        = string
  validation {
    condition     = length(var.infra_resource_group_name) > 3 && length(var.infra_resource_group_name) < 50
    error_message = "Resource group name must be between 3 and 50 characters."
  }
}

variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
}

variable "db_server_name" {
  description = "Name of the PostgreSQL server."
  type        = string
  validation {
    condition     = length(var.db_server_name) > 3 && length(var.db_server_name) < 50
    error_message = "Server name must be between 3 and 50 characters."
  }
}

variable "db_admin_user" {
  description = "PostgreSQL admin username."
  type        = string
}

variable "db_admin_pass" {
  description = "PostgreSQL admin password."
  type        = string
  sensitive   = true
}

variable "postgresql_sku" {
  description = "The SKU for the PostgreSQL flexible server."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "postgresql_storage_tier" {
  description = "The storage tier for the PostgreSQL server (e.g., P4, P10)."
  type        = string
  default     = "P4"
  validation {
    condition     = contains(["P4", "P10", "P20", "P30", "P40", "P50"], var.postgresql_storage_tier)
    error_message = "Valid storage tiers are P4, P10, P20, P30, P40, P50."
  }
}

variable "postgresql_storage_mb" {
  description = "Storage size for PostgreSQL server (in MB)."
  type        = number
  default     = 32768
}

variable "postgresql_backup_retention_days" {
  description = "Backup retention days for PostgreSQL server."
  type        = number
  default     = 7
}

variable "db_name" {
  description = "Database name to create inside PostgreSQL server."
  type        = string
}

variable "app_service_name" {
  description = "Name of the Azure Web App (App Service)."
  type        = string
  validation {
    condition     = length(var.app_service_name) > 3 && length(var.app_service_name) < 60 && can(regex("^[a-zA-Z0-9-]+$", var.app_service_name))
    error_message = "App Service name must be 3-60 characters and contain only alphanumeric characters or hyphens."
  }
}

variable "docker_registry_server" {
  description = "The address of the Docker registry server (e.g., docker.io, quay.io, or a private registry)"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]+(:[0-9]+)?$", var.docker_registry_server)) || var.docker_registry_server == ""
    error_message = "Docker registry server must be a valid hostname or hostname:port, or an empty string for the default registry."
  }
  default = ""
}

variable "docker_image_name" {
  description = "The name of the Docker image"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_.-]+$", var.docker_image_name))
    error_message = "Docker image name must start with alphanumeric and contain only alphanumeric, underscores, dots, or hyphens."
  }
}

variable "docker_image_tag" {
  description = "The tag/version of the Docker image"
  type        = string
  default     = "latest"
}
variable "location" {
  description = "Azure region for resources (e.g., West Europe, East US)"
  type        = string
  default     = "West Europe"
}
