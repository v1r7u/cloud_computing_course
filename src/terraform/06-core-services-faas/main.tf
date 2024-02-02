terraform {
  required_version = "~>1.7.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.90.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

module "observability" {
  source = "../modules/observability"
  prefix   = var.prefix
  location = var.location
}

module "faas" {
  source = "../modules/faas"

  prefix   = var.prefix
  location = var.location

  log_analytics_workspace_id = module.observability.log_analytics_workspace_id
}
