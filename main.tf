provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
    name     = "${var.prefix}-resources"
    location = var.location
    tags = {
      "ENV" = "DESTROY"
    }
}

resource "azurerm_virtual_network" "main" {
    name                = "${var.prefix}-network"
    address_space       = [ "10.0.0.0/16" ]
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    tags = {
      "ENV" = "DESTROY"
    }
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "main" {
  name                         = "mypublicip"
  location                     = azurerm_resource_group.main.location
  resource_group_name          = azurerm_resource_group.main.name
  allocation_method            = "Dynamic"

  tags = {
    "ENV" = "DESTROY"
  }
}
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
  tags = {
    "ENV" = "DESTROY"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.prefix}-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = var.vmsize
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id,
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
    "ENV" = "DESTROY"
  }
}