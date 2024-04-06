resource "azurerm_linux_virtual_machine" "private" {
  name                            = "${var.prefix}-private-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = var.vm_size
  admin_username                  = "adminuser"
  disable_password_authentication = true
  
  network_interface_ids = [
    azurerm_network_interface.vm_private.id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.vm_admin.public_key_openssh
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

resource "azurerm_network_interface" "vm_private" {
  name                = "${var.prefix}-vm-private-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.vms_private.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_private_pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "private_vm_sg" {
  network_interface_id      = azurerm_network_interface.vm_private.id
  network_security_group_id = azurerm_network_security_group.main.id
}
