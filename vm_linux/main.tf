resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.prefix}-vm"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.size
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    var.network_interface
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  tags = {
    (var.tag_name) = (var.tag_value)
  }
}