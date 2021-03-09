output "out_rg_name" {
  description = "The name of the new RG"
  value = azurerm_resource_group.main.name
}

output "vm_public_ip" {
  description = "The IP of the new VM"
  value = azurerm_public_ip.main.ip_address
}