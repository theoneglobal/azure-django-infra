# Infrastructure Resource Group
resource "azurerm_resource_group" "infra_rg" {
  name     = var.infra_resource_group_name
  location = var.location
  tags     = var.tags
}

# App Service Plan for Django application
resource "azurerm_service_plan" "app_service_plan" {
  name                = "${local.safe_prefix}-appserviceplan"
  resource_group_name = azurerm_resource_group.infra_rg.name
  location            = azurerm_resource_group.infra_rg.location
  os_type             = "Linux"
  sku_name            = "S1"
}

# App Service for Django application
resource "azurerm_linux_web_app" "app_service" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.infra_rg.name
  location            = azurerm_resource_group.infra_rg.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version           = "3.13"
      docker_registry_url      = "https://${var.docker_login_server}"
      docker_image_name        = "${var.docker_image_name}:${var.docker_image_tag}"
      docker_registry_username = null
      docker_registry_password = null
    }
  }

  app_settings = {
    DATABASE_URL          = "postgres://${module.postgres.postgresql_admin_user}:${module.postgres.postgresql_admin_password}@${module.postgres.postgresql_server_fqdn}:5432/${module.postgres.postgresql_database_name}"
    DB_NAME               = module.postgres.postgresql_database_name
    STORAGE_ACCOUNT_NAME  = azurerm_storage_account.django_storage.name
    STORAGE_ACCOUNT_KEY   = azurerm_storage_account.django_storage.primary_access_key
    MEDIA_CONTAINER_NAME  = azurerm_storage_share.django_media.name
    STATIC_CONTAINER_NAME = azurerm_storage_share.django_static.name
    STORAGE_ACCOUNT_URL   = "https://${azurerm_storage_account.django_storage.name}.blob.core.windows.net"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.app_service.identity[0].principal_id

  depends_on = [azurerm_linux_web_app.app_service]
}

# ──────────── MODULES ───────────── #
module "postgres" {
  source                = "./modules/postgres"
  resource_group_name   = azurerm_resource_group.infra_rg.name
  location              = var.location
  server_name           = var.db_server_name
  admin_user            = var.db_admin_user
  admin_password        = var.db_admin_pass
  sku                   = var.postgresql_sku
  storage_tier          = var.postgresql_storage_tier
  storage_mb            = var.postgresql_storage_mb
  backup_retention_days = var.postgresql_backup_retention_days
  database_name         = var.db_name
  tags                  = var.tags
}
