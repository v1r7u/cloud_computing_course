output "azure_web_jobs_storage" {
  value = module.faas_eh_sa.azure_web_jobs_storage
  sensitive = true
}

output "event_hub_name" {
  value = module.faas_eh_sa.event_hub_name
  sensitive = true
}

output "event_hub_connection_string" {
  value = module.faas_eh_sa.event_hub_connection_string
  sensitive = true
}

output "storage_account_connection_string" {
  value = module.faas_eh_sa.storage_account_connection_string
  sensitive = true
}

output "storage_account_containername" {
  value = module.faas_eh_sa.storage_account_containername
  sensitive = true
}

output "azure_function_name" {
  value = module.faas_eh_sa.azure_function_name
  sensitive = true
}
