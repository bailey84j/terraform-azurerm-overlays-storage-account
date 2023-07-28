# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/* data "azuread_group" "vm_admins_group" {
  display_name = "Virtual Machines Admins"
}

data "azuread_group" "vm_users_group" {
  display_name = "Virtual Machines Users"
}
 */
resource "azurerm_resource_group" "storage-rg" {
  name     = "storage-vm-rg"
  location = var.location
  tags = {
    environment = "test"
  }
}

resource "azurerm_virtual_network" "storage-vnet" {
  depends_on = [
    azurerm_resource_group.storage-rg
  ]
  name                = "vm-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.storage-rg.name
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = "test"
  }
}

resource "azurerm_subnet" "storage-snet" {
  depends_on = [
    azurerm_resource_group.storage-rg,
    azurerm_virtual_network.storage-vnet
  ]
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.storage-rg.name
  virtual_network_name = azurerm_virtual_network.storage-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "storage-nsg" {
  depends_on = [
    azurerm_resource_group.storage-rg,
  ]
  name                = "vm-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.storage-rg.name
  tags = {
    environment = "test"
  }
}

resource "azurerm_log_analytics_workspace" "storage-log" {
  depends_on = [
    azurerm_resource_group.storage-rg
  ]
  name                = "vm-log"
  location            = var.location
  resource_group_name = azurerm_resource_group.storage-rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = {
    environment = "test"
  }
}
