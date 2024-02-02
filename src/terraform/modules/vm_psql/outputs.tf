output "tls_private_key" { 
  value = tls_private_key.vm_admin.private_key_pem
  sensitive = true
}

output "private_vm_ip" { 
  value = azurerm_public_ip.vm_private_pip.ip_address
  sensitive = true
}

output "public_vm_ip" { 
  value = azurerm_public_ip.vm_public_pip.ip_address
  sensitive = true
}

output "private_psql_hostname" { 
  value = azurerm_postgresql_flexible_server.private.name
  sensitive = true
}

output "public_psql_hostname" { 
  value = azurerm_postgresql_flexible_server.public.name
  sensitive = true
}
