resource "azurerm_windows_virtual_machine" "main" {
  name                = "${var.prefix}-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.username
  admin_password      = var.password
  network_interface_ids = [
    var.network_interface
  ]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-smalldisk"
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