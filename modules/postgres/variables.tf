variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}
variable "location" {
  description = "The Azure region for the PostgreSQL server."
  type        = string
}
variable "server_name" {
  description = "The name of the PostgreSQL server."
  type        = string
  validation {
    condition     = length(var.server_name) > 3 && length(var.server_name) < 50
    error_message = "Server name must be between 3 and 50 characters."
  }
}
variable "admin_user" {
  description = "The administrator username for PostgreSQL."
  type        = string
}
variable "admin_password" {
  description = "The administrator password for PostgreSQL."
  type        = string
  sensitive   = true
}
variable "sku" {
  description = "The SKU for the PostgreSQL flexible server."
  type        = string
  default     = "B_Standard_B1ms"
}
variable "storage_tier" {
  description = "The storage tier for the PostgreSQL server (e.g., P4, P10)."
  type        = string
  default     = "P4"
  validation {
    condition     = contains(["P4", "P10", "P20", "P30", "P40", "P50"], var.storage_tier)
    error_message = "Valid storage tiers are P4, P10, P20, P30, P40, P50."
  }
}
variable "storage_mb" {
  description = "The amount of storage (in MB) for the PostgreSQL server."
  type        = number
  default     = 32768
  validation {
    condition     = var.storage_mb >= 5120 && var.storage_mb <= 102400
    error_message = "Storage must be between 5120MB and 102400MB."
  }
}
variable "backup_retention_days" {
  description = "The number of days to retain backups."
  type        = number
  default     = 7
}
variable "database_name" {
  description = "The name of the PostgreSQL database."
  type        = string
}
variable "tags" {
  description = "Tags for the PostgreSQL resources."
  type        = map(string)
  default     = {}
}
