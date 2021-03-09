provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "project01" {
    name     = "${var.prefix}-resources"
    location = var.location
}

resource "azurerm_virtual_network" "project01" {
    name                = "${var.prefix}-network"
    address_space       = [ "10.0.0.0/16" ]
    location            = azurerm_resource_group.project01.location
    resource_group_name = azurerm_resource_group.project01.name
}
