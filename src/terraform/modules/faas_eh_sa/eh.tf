resource "azurerm_eventhub_namespace" "ehn" {
  name                = "${var.prefix}${random_string.faas_salt.result}-eh"
  location            = azurerm_resource_group.faas_eh_sa.location
  resource_group_name = azurerm_resource_group.faas_eh_sa.name

  sku      = "Standard"
  capacity = 1

  auto_inflate_enabled     = true
  maximum_throughput_units = 5

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

resource "azurerm_eventhub" "eh_raw" {
  name                = "iot_events_raw"
  namespace_name      = azurerm_eventhub_namespace.ehn.name
  resource_group_name = azurerm_resource_group.faas_eh_sa.name

  partition_count   = 3
  message_retention = 1
}

resource "azurerm_monitor_diagnostic_setting" "event_hub_logs" {
  name = "eventhublogs"

  target_resource_id         = azurerm_eventhub_namespace.ehn.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "ArchiveLogs"

    retention_policy {
      enabled = true
      days = 30
    }
  }
  log {
    category = "OperationalLogs"

    retention_policy {
      enabled = true
      days = 30
    }
  }
  log {
    category = "AutoScaleLogs"

    retention_policy {
      enabled = true
      days = 30
    }
  }
  log {
    category = "KafkaCoordinatorLogs"

    retention_policy {
      enabled = true
      days = 30
    }
  }
  log {
    category = "KafkaUserErrorLogs"

    retention_policy {
      enabled = true
      days = 30
    }
  }
  log {
    category = "EventHubVNetConnectionEvent"

    retention_policy {
      enabled = true
      days = 30
    }
  }
  log {
    category = "CustomerManagedKeyUserLogs"

    retention_policy {
      enabled = true
      days = 30
    }
  }
  log {
      category = "ApplicationMetricsLogs"

      retention_policy {
          enabled = true
          days    = 30
      }
  }
  log {
      category = "RuntimeAuditLogs"

      retention_policy {
          enabled = true
          days    = 30
      }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days = 30
    }
  }
}
