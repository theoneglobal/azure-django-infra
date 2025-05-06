output "resource_group_name" {
  description = "The name of the resource group."
  value       = azurerm_resource_group.infra_rg.name
}
output "location" {
  description = "Azure region where the infrastructure is deployed."
  value       = azurerm_resource_group.infra_rg.location
}
output "postgresql_server_fqdn" {
  description = "The FQDN of the PostgreSQL server."
  value       = module.postgres.postgresql_server_fqdn
}
output "storage_account_name" {
  description = "Storage account name for Django media and static files."
  value       = azurerm_storage_account.django_storage.name
}
output "app_service_url" {
  description = "Public URL of the Django web app."
  value       = "https://${azurerm_linux_web_app.app_service.default_hostname}"
}

