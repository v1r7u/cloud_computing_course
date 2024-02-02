variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
}

variable "psql_admin" {
  description = "PSQL admin name"
}

variable "psql_password" {
  description = "PSQL admin password"
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace Identifier"
}

variable "psql_storage_size" {
  description = "Storage size in Mb"
  default     = 32768
}

variable "psql_sku" {
  description = "PSQL sku"
  default     = "GP_Standard_D4ds_v4"
}

variable "vm_size" {
  description = "VM sku"
  default     = "Standard_D8_v4"
}

variable "ssh_pub_key_path" {
  description = "Path to public key"
  default     = "~/.ssh/id_rsa.pub"
}
