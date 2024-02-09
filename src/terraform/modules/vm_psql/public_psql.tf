resource "azurerm_postgresql_flexible_server" "public" {
  name                   = "${var.prefix}-postgresql-pub"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  version                = "16"
  storage_mb             = var.psql_storage_size
  sku_name               = var.psql_sku
  administrator_login    = random_pet.psql_admin.id
  administrator_password = random_password.psql_password.result
  backup_retention_days  = 7
  zone                   = "1"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_postgresql_flexible_server_database" "public_db" {
  name      = "exampledb"
  server_id = azurerm_postgresql_flexible_server.public.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "psql_public_fw_rule_1" {
  name             = "vm-public"
  server_id        = azurerm_postgresql_flexible_server.public.id
  start_ip_address = azurerm_public_ip.vm_public_pip.ip_address
  end_ip_address   = azurerm_public_ip.vm_public_pip.ip_address
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "psql_public_fw_rule_2" {
  name             = "vm-private"
  server_id        = azurerm_postgresql_flexible_server.public.id
  start_ip_address = azurerm_public_ip.vm_private_pip.ip_address
  end_ip_address   = azurerm_public_ip.vm_private_pip.ip_address
}

resource "azurerm_monitor_diagnostic_setting" "psql_public_logs" {
  name = "logs"

  target_resource_id         = azurerm_postgresql_flexible_server.public.id
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
