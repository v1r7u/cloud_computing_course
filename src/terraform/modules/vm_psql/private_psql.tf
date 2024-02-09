resource "azurerm_postgresql_flexible_server" "private" {
  name                   = "${var.prefix}-postgresql-priv"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  version                = "16"
  storage_mb             = var.psql_storage_size
  sku_name               = var.psql_sku
  administrator_login    = random_pet.psql_admin.id
  administrator_password = random_password.psql_password.result
  backup_retention_days  = 7

  delegated_subnet_id    = azurerm_subnet.dbs.id
  private_dns_zone_id    = azurerm_private_dns_zone.priv_psql.id
  zone                   = "1"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_postgresql_flexible_server_database" "private_db" {
  name      = "exampledb"
  server_id = azurerm_postgresql_flexible_server.private.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

resource "azurerm_monitor_diagnostic_setting" "psql_private_logs" {
  name = "logs"

  target_resource_id         = azurerm_postgresql_flexible_server.private.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "PostgreSQLFlexDatabaseXacts"
  }
  enabled_log {
    category = "PostgreSQLFlexQueryStoreRuntime"
  }
  enabled_log {
    category = "PostgreSQLFlexQueryStoreWaitStats"
  }
  enabled_log {
    category = "PostgreSQLFlexSessions"
  }
  enabled_log {
    category = "PostgreSQLFlexTableStats"
  }
  enabled_log {
    category = "PostgreSQLLogs"
  }
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
