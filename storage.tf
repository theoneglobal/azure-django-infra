resource "azurerm_storage_account" "django_storage" {
  name                     = "${local.safe_prefix}storage"
  resource_group_name      = azurerm_resource_group.infra_rg.name
  location                 = azurerm_resource_group.infra_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "django_media" {
  name                 = "media"
  storage_account_name = azurerm_storage_account.django_storage.name
  quota                = 50
}

resource "azurerm_storage_share" "django_static" {
  name                 = "static"
  storage_account_name = azurerm_storage_account.django_storage.name
  quota                = 20
}
