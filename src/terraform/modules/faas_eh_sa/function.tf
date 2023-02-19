locals {
  function_app_name     = "${var.prefix}-${random_string.faas_salt.result}-func"
  app_service_plan_name = "${local.function_app_name}-plan"
  app_insights_name     = "${local.function_app_name}-appinsights"
}

resource "azurerm_storage_account" "faas_storage" {
  name                     = "${var.prefix}${random_string.faas_salt.result}funcsa"
  resource_group_name      = azurerm_resource_group.faas_eh_sa.name
  location                 = azurerm_resource_group.faas_eh_sa.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.common_tags
}

resource "azurerm_app_service_plan" "faas" {
  name                = local.app_service_plan_name
  location            = azurerm_resource_group.faas_eh_sa.location
  resource_group_name = azurerm_resource_group.faas_eh_sa.name
  kind                = "functionapp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  tags = local.common_tags
}

resource "azurerm_application_insights" "app_insights" {
  name                = local.app_insights_name
  location            = azurerm_resource_group.faas_eh_sa.location
  resource_group_name = azurerm_resource_group.faas_eh_sa.name
  application_type    = "web"

  daily_data_cap_in_gb = 10
  retention_in_days    = 90
  sampling_percentage  = 100

  tags = local.common_tags
}

resource "azurerm_function_app" "faas" {
  name                       = local.function_app_name
  location                   = azurerm_resource_group.faas_eh_sa.location
  resource_group_name        = azurerm_resource_group.faas_eh_sa.name
  app_service_plan_id        = azurerm_app_service_plan.faas.id
  storage_account_name       = azurerm_storage_account.faas_storage.name
  storage_account_access_key = azurerm_storage_account.faas_storage.primary_access_key
  os_type                    = "linux"
  version                    = "~3"

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "AzureWebJobsStorage": azurerm_storage_account.faas_storage.primary_connection_string,
    "eventHubName": azurerm_eventhub.eh_raw.name,
    "CloudComputingEventHubConnectionString": azurerm_eventhub_namespace.ehn.default_primary_connection_string,
    "StorageAccountConnectionString": azurerm_storage_account.sa.primary_connection_string,
    "StorageAccountContainerName": azurerm_storage_container.events.name,
    "APPINSIGHTS_INSTRUMENTATIONKEY": azurerm_application_insights.app_insights.instrumentation_key
  }

  tags = local.common_tags
}
