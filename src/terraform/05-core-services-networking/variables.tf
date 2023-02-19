variable "subscription_id" {
  description = "Azure subscription identifier"
}

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

variable "psql_storage_size" {
  description = "Storage size in Mb"
  default     = 102400
}

variable "psql_sku" {
  description = "PSQL sku"
  default     = "GP_Gen5_4"
}

variable "vm_size" {
  description = "VM sku"
  default     = "Standard_D2_v4"
}
