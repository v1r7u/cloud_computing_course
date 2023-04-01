locals {
  common_tags = {
    terraform = true
    project   = "cloud-computing-course"
  }
}

resource "azurerm_resource_group" "faas" {
  name     = "${var.prefix}-faas-rg"
  location = var.location

  tags = local.common_tags
}

resource "random_string" "faas_salt" {
  length  = 4
  special = false
  upper   = false
}
