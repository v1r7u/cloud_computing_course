resource "azurerm_postgresql_flexible_server" "public" {
  name                   = "${var.prefix}-postgresql-pub"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  version                = "16"
  storage_mb             = var.psql_storage_size
  sku_name               = var.psql_sku
  administrator_login    = var.psql_admin
  administrator_password = var.psql_password
  backup_retention_days  = 7

  tags = {
    environment = "Production"
  }
}

resource "azurerm_postgresql_flexible_server_database" "public_db" {
  name      = "exampledb"
  server_id = azurerm_postgresql_flexible_server.public.id
  collation = "en_US.utf8"
  charset   = "utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_postgresql_firewall_rule" "psql_public_fw_rule" {
  name                = "vm-public"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_flexible_server.public.name
  start_ip_address    = azurerm_public_ip.vm_public_pip.ip_address
  end_ip_address      = azurerm_public_ip.vm_public_pip.ip_address
}

resource "azurerm_monitor_diagnostic_setting" "psql_public_logs" {
  name = "logs"

  target_resource_id         = azurerm_postgresql_flexible_server.public.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "PostgreSQLLogs"

    retention_policy {
      enabled = true
      days = 30
    }
  }

  log {
    category = "QueryStoreRuntimeStatistics"
    enabled  = false

    retention_policy {
      enabled = false
      days = 0
    }
  }

  log {
    category = "QueryStoreWaitStatistics"
    enabled  = false

    retention_policy {
      enabled = false
      days = 0
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
