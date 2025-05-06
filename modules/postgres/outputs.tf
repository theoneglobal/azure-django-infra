output "postgresql_admin_user" {
  description = "The administrator username for PostgreSQL."
  value       = azurerm_postgresql_flexible_server.mhs_pg_fs.administrator_login
}

output "postgresql_admin_password" {
  description = "The administrator password for PostgreSQL."
  value       = azurerm_postgresql_flexible_server.mhs_pg_fs.administrator_password
  sensitive   = true # ✅ Ensuring security by marking this sensitive
}

output "postgresql_server_id" {
  description = "The unique resource ID of the PostgreSQL server."
  value       = azurerm_postgresql_flexible_server.mhs_pg_fs.id
}

output "postgresql_server_fqdn" {
  description = "The FQDN of the PostgreSQL server."
  value       = azurerm_postgresql_flexible_server.mhs_pg_fs.fqdn
}

output "postgresql_version" {
  description = "The version of PostgreSQL deployed."
  value       = azurerm_postgresql_flexible_server.mhs_pg_fs.version
}

output "postgresql_storage_mb" {
  description = "The allocated storage for the PostgreSQL flexible server."
  value       = azurerm_postgresql_flexible_server.mhs_pg_fs.storage_mb
}

output "postgresql_backup_retention_days" {
  description = "Backup retention period in days."
  value       = azurerm_postgresql_flexible_server.mhs_pg_fs.backup_retention_days
}

output "postgresql_private_dns_zone_id" {
  description = "The ID of the Private DNS zone linked to the PostgreSQL server."
  value       = azurerm_postgresql_flexible_server.mhs_pg_fs.private_dns_zone_id
}

output "postgresql_connection_string" {
  description = "The connection string for the PostgreSQL database."
  value       = "postgres://${azurerm_postgresql_flexible_server.mhs_pg_fs.administrator_login}:${var.admin_password}@${azurerm_postgresql_flexible_server.mhs_pg_fs.fqdn}:5432/${azurerm_postgresql_flexible_server_database.mhs_pg_django.name}"
  sensitive   = true
}

output "postgresql_database_name" {
  description = "The name of the PostgreSQL database."
  value       = azurerm_postgresql_flexible_server_database.mhs_pg_django.name
}

output "postgresql_public_network_access_enabled" {
  description = "Indicates whether public network access is enabled for PostgreSQL."
  value       = azurerm_postgresql_flexible_server.mhs_pg_fs.public_network_access_enabled
}
