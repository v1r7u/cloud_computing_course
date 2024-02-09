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

  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
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
}

resource "azurerm_subnet_network_security_group_association" "vms_public" {
  subnet_id                 = azurerm_subnet.vms_public.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "vms_private" {
  subnet_id                 = azurerm_subnet.vms_private.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "dbs" {
  subnet_id                 = azurerm_subnet.dbs.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# SSH to VMs
resource "azurerm_network_security_rule" "allow_ssh_pub" {
  name                        = "allow-ssh-to-vm-pub"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name

  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_address_prefixes  = azurerm_subnet.vms_public.address_prefixes
  destination_port_range      = "22"
}

resource "azurerm_network_security_rule" "allow_ssh_priv" {
  name                        = "allow-ssh-to-vm_priv"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name

  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_address_prefixes  = azurerm_subnet.vms_private.address_prefixes
  destination_port_range      = "22"
}

# Network Security Group for PostgreSQL
resource "azurerm_network_security_rule" "allow_to_psql_from_priv" {
  name                        = "allow-to-psql-from-priv-vm"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name

  priority                    = 2000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefixes       = azurerm_subnet.vms_private.address_prefixes
  destination_address_prefixes  = azurerm_subnet.dbs.address_prefixes
  destination_port_range      = "5432"
}

resource "azurerm_network_security_rule" "deny_all_to_psql" {
  name                        = "deny-all-to-psql"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name

  priority                    = 2010
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_address_prefixes  = azurerm_subnet.dbs.address_prefixes
  destination_port_range      = "*"
}

resource "azurerm_private_dns_zone" "priv_psql" {
  name                = "private.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "priv_psql" {
  name                  = "cloudcomputing.com"
  private_dns_zone_name = azurerm_private_dns_zone.priv_psql.name
  virtual_network_id    = azurerm_virtual_network.main.id
  resource_group_name   = azurerm_resource_group.main.name
  depends_on            = [azurerm_subnet.dbs]
}
