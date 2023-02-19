variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
}

variable "min_tls_version" {
  description = "Storage Account minimum allowed TLS version. Supported values are: TLS1_0, TLS1_1, and TLS1_2"
  default = "TLS1_0"
}
