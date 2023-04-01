resource "azurerm_eventgrid_topic" "events" {
  name                = "${var.prefix}${random_string.faas_salt.result}-events"
  location            = azurerm_resource_group.faas.location
  resource_group_name = azurerm_resource_group.faas.name

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

resource "azurerm_eventgrid_event_subscription" "events" {
  name  = "events-subscription"
  scope = azurerm_eventgrid_topic.events.id

  azure_function_endpoint {
    function_id           = "${azurerm_function_app.faas.id}/functions/EventGridToTable"
    max_events_per_batch  = 1
  }

  retry_policy {
    max_delivery_attempts = 3
    event_time_to_live    = 60
  }
}


