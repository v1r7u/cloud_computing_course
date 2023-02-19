resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "vms_private" {
  name                 = "vms_private"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]

  service_endpoints = [ "Microsoft.Sql" ]
}

resource "azurerm_subnet" "vms_public" {
  name                 = "vms-public"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "dbs" {
  name                 = "dbs"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.4.0/24"]

  enforce_private_link_endpoint_network_policies = true
}

/*
> Dynamic Public IP Addresses aren't allocated until they're attached to a device (e.g. a Virtual Machine/Load Balancer).
> Instead you can obtain the IP Address once the Public IP has been assigned via the azurerm_public_ip Data Source.

Thus,
- azurerm_public_ip.vm_public_pip will have `ip_address` attribute immediately, which is crucial for dependent public-psql firewall-rule resource
- azurerm_public_ip.vm_private_pip will have empty `ip_address` attribute, until private_vm is finally created
*/

resource "azurerm_public_ip" "vm_public_pip" {
  name                = "${var.prefix}-vm-public-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "vm_private_pip" {
  name                = "${var.prefix}-vm-private-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "main" {
  name                = "secgroup"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "22"
    destination_address_prefix = "*"
  }
}
