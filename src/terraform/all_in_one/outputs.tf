output "azure_web_jobs_storage" {
  value = module.faas.azure_web_jobs_storage
  sensitive = true
}

output "events_topic_endpoint" {
  value = module.faas.events_topic_endpoint
  sensitive = true
}

output "events_topic_key" {
  value = module.faas.events_topic_key
  sensitive = true
}

output "storage_account_connection_string" {
  value = module.faas.storage_account_connection_string
  sensitive = true
}

output "storage_account_tablename" {
  value = module.faas.storage_account_tablename
  sensitive = true
}

output "azure_function_name" {
  value = module.faas.azure_function_name
  sensitive = true
}
