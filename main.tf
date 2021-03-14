provider "azurerm" {
  features {}
}

# define your own storage_account_name and export ARM_ACCESS_KEY
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstates"
    storage_account_name = "tfstatesaldenso"
    container_name       = "terraform"
    key                  = "terraform_vm.tfstate"
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
  tags = {
    (var.tag_name) = (var.tag_value)
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = {
    (var.tag_name) = (var.tag_value)
  }
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "main" {
  name                = "mypublicip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"

  tags = {
    (var.tag_name) = (var.tag_value)
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
    (var.tag_name) = (var.tag_value)
  }
}

module "vmlinux" {
  count               = var.distro == "Linux" ? 1 : 0
  source              = "./vm_linux"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vmsize[var.size]
  username            = var.username
  password            = var.password
  network_interface   = azurerm_network_interface.main.id
  tag_name            = var.tag_name
  tag_value           = var.tag_value
}

module "vmwindows" {
  count               = var.distro == "Windows" ? 1 : 0
  source              = "./vm_windows"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vmsize[var.size]
  username            = var.username
  password            = var.password
  network_interface   = azurerm_network_interface.main.id
  tag_name            = var.tag_name
  tag_value           = var.tag_value
}
