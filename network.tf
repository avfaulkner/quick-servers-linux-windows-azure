# Create a resource group for all resources
resource "azurerm_resource_group" "quick-server-resgrp" {
  name     = "quick-server-resources"
  location = "eastus"

  tags = {
    Name = "quick-server-resources"
  }
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "quick-server-network" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.quick-server-resgrp.name
  location            = azurerm_resource_group.quick-server-resgrp.location
  address_space       = ["10.0.0.0/16"]
}

# Route tables
# Public


# Subnets
# Public
resource "azurerm_subnet" "subnet-public" {
  name                 = "quick-server-subnet-pub"
  resource_group_name  = azurerm_resource_group.quick-server-resgrp.name
  virtual_network_name = azurerm_virtual_network.quick-server-network.name
  address_prefixes       = ["10.0.10.0/24"]
}

resource "azurerm_public_ip" "quick-server-ip" {
  location = "eastus"
  name = "quick-server-ip"
  resource_group_name = azurerm_resource_group.quick-server-resgrp.name
  allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "quick-server-nic" {
  name                        = "quick-server-nic"
  location                    = "eastus"
  resource_group_name         = azurerm_resource_group.quick-server-resgrp.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.subnet-public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.quick-server-ip.id
  }

  tags = {
    Name = "quick-server-nic"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "sg-nic" {
  network_interface_id      = azurerm_network_interface.quick-server-nic.id
  network_security_group_id = azurerm_network_security_group.quick-server-sg.id
}

# Storage account. The storage account is only to store the boot diagnostics data
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.quick-server-resgrp.name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "mystorageaccount" {
  name                        = "diag${random_id.randomId.hex}"
  resource_group_name         = azurerm_resource_group.quick-server-resgrp.name
  location                    = "eastus"
  account_replication_type    = "LRS"
  account_tier                = "Standard"

  tags = {
    Name = "quick-server-storage-account"
  }
}