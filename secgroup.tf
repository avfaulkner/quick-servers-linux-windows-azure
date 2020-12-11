# server security group
resource "azurerm_network_security_group" "quick-server-sg" {
  name                = "myNetworkSecurityGroup"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.quick-server-resgrp.name

  tags = {
    Name = "quick-server-sg"
  }
}

# inbound ssh access
resource "azure_security_group_rule" "ssh-in" {
  name                       = "ssh access"
  type                       = "Inbound"
  action                     = "Allow"
  priority                   = 200
  source_address_prefix      = var.ssh_cidr_blocks
  source_port_range          = "*"
  destination_address_prefix = azure_instance.quick-server.ip_address # TODO use public IP
  destination_port_range     = "22"
  protocol                   = "TCP"
  security_group_names = azurerm_network_security_group.quick-server-sg.name
}

# https inbound
resource "azure_security_group_rule" "https-in" {
  name                       = "https-in"
  type                       = "Inbound"
  action                     = "Allow"
  priority                   = 200
  source_address_prefix      = var.ssh_cidr_blocks
  source_port_range          = "*"
  destination_address_prefix = azure_instance.quick-server.ip_address # TODO use public IP
  destination_port_range     = "443"
  protocol                   = "TCP"
  security_group_names = azurerm_network_security_group.quick-server-sg.name
}

# https outbound
resource "azure_security_group_rule" "https-out" {
  name                       = "https access"
  type                       = "Outbound"
  action                     = "Allow"
  priority                   = 200
  source_address_prefix      = azure_instance.quick-server.ip_address
  source_port_range          = "*"
  destination_address_prefix = ["0.0.0.0/0"]
  destination_port_range     = "443"
  protocol                   = "TCP"
  security_group_names = azurerm_network_security_group.quick-server-sg.name
}

# http outbound
resource "azure_security_group_rule" "http-out" {
  name                       = "http access"
  type                       = "Outbound"
  action                     = "Allow"
  priority                   = 200
  source_address_prefix      = azure_instance.quick-server.ip_address
  source_port_range          = "*"
  destination_address_prefix = ["0.0.0.0/0"]
  destination_port_range     = "80"
  protocol                   = "TCP"
  security_group_names = azurerm_network_security_group.quick-server-sg.name
}
