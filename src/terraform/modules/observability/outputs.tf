output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
  sensitive = true
}
