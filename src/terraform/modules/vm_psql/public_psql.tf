resource "azurerm_postgresql_server" "public" {
  name                = "${var.prefix}-postgresql-pub"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  administrator_login          = var.psql_admin
  administrator_login_password = var.psql_password
  auto_grow_enabled            = true
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  ssl_enforcement_enabled      = true
  sku_name                     = var.psql_sku
  storage_mb                   = var.psql_storage_size
  version                      = "11"
}

resource "azurerm_postgresql_database" "public_db" {
  name                = "exampledb"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.public.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "psql_public_fw_rule" {
  name                = "vm-public"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.public.name
  start_ip_address    = azurerm_public_ip.vm_public_pip.ip_address
  end_ip_address      = azurerm_public_ip.vm_public_pip.ip_address
}

resource "azurerm_monitor_diagnostic_setting" "psql_public_logs" {
  name = "logs"

  target_resource_id         = azurerm_postgresql_server.public.id
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
