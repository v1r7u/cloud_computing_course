resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "tls_private_key" "vm_admin" {
  algorithm = "RSA"
  rsa_bits = 4096
}
