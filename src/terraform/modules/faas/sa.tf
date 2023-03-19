resource "azurerm_storage_account" "sa" {
  name                = "${var.prefix}${random_string.faas_salt.result}sa"
  location            = azurerm_resource_group.faas.location
  resource_group_name = azurerm_resource_group.faas.name

  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"

  tags = local.common_tags
}

resource "azurerm_storage_table" "events" {
  name                 = "events"
  storage_account_name = azurerm_storage_account.sa.name
}
