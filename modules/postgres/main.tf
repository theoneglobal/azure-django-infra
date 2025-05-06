resource "azurerm_postgresql_flexible_server" "mhs_pg_fs" {
  name                   = var.server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.admin_user
  administrator_password = var.admin_password
  sku_name               = var.sku
  zone                   = "1"
  version                = "16"
  storage_tier           = var.storage_tier
  storage_mb             = var.storage_mb
  tags                   = var.tags
}
resource "azurerm_postgresql_flexible_server_database" "mhs_pg_django" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.mhs_pg_fs.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.mhs_pg_fs.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
