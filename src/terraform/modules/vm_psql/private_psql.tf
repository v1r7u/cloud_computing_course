resource "azurerm_postgresql_server" "private" {
  name                = "${var.prefix}-postgresql-priv"
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

resource "azurerm_postgresql_database" "example" {
  name                = "exampledb"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.private.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_private_endpoint" "psql" {
  name                 = "${var.prefix}-psql-pe"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  subnet_id            = azurerm_subnet.dbs.id

  private_service_connection {
    name                           = "tfex-postgresql-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_postgresql_server.private.id
    subresource_names              = ["postgresqlServer"]
  }
}

resource "azurerm_postgresql_virtual_network_rule" "psql_private_fw_rule" {
  name                = "postgresql-vnet-rule"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.private.name
  subnet_id           = azurerm_subnet.vms_private.id
}

resource "azurerm_monitor_diagnostic_setting" "psql_private_logs" {
  name = "logs"

  target_resource_id         = azurerm_postgresql_server.private.id
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
