locals {
  function_app_name     = "${var.prefix}-${random_string.faas_salt.result}-func"
  app_service_plan_name = "${local.function_app_name}-plan"
  app_insights_name     = "${local.function_app_name}-appinsights"
}

resource "azurerm_storage_account" "faas_storage" {
  name                     = "${var.prefix}${random_string.faas_salt.result}funcsa"
  resource_group_name      = azurerm_resource_group.faas.name
  location                 = azurerm_resource_group.faas.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.common_tags
}

resource "azurerm_application_insights" "app_insights" {
  name                = local.app_insights_name
  location            = azurerm_resource_group.faas.location
  resource_group_name = azurerm_resource_group.faas.name
  application_type    = "web"

  daily_data_cap_in_gb = 10
  retention_in_days    = 90
  sampling_percentage  = 100

  tags = local.common_tags
}

resource "azurerm_service_plan" "faas" {
  name                = local.app_service_plan_name
  location            = azurerm_resource_group.faas.location
  resource_group_name = azurerm_resource_group.faas.name
  os_type             = "Linux"
  sku_name            = "Y1"

  tags = local.common_tags
}

data "archive_file" "faas" {
  type        = "zip"
  source_dir = "${path.module}/../../../az_func"
  output_path = "${path.module}/files/func.zip"
}

resource "azurerm_linux_function_app" "faas" {
  name                = local.function_app_name
  location            = azurerm_resource_group.faas.location
  resource_group_name = azurerm_resource_group.faas.name
  service_plan_id     = azurerm_service_plan.faas.id
  storage_account_name       = azurerm_storage_account.faas_storage.name
  storage_account_access_key = azurerm_storage_account.faas_storage.primary_access_key

  functions_extension_version = "~4"

  site_config {
    application_insights_key = azurerm_application_insights.app_insights.instrumentation_key

    application_stack {
      python_version = "3.10"
    }
  }

  zip_deploy_file = data.archive_file.faas.output_path

  app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
    "eventGridTopicEndpoint": azurerm_eventgrid_topic.events.endpoint,
    "eventGridTopicKey": azurerm_eventgrid_topic.events.primary_access_key,
    "StorageAccountConnectionString": azurerm_storage_account.sa.primary_connection_string,
    "storageAccountTableName": azurerm_storage_table.events.name,
  }

  tags = local.common_tags
}
