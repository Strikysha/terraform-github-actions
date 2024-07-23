locals {
  acronym = "yury-lab-04-1"
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${local.acronym}"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "vnet-${local.acronym}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "subnet-${local.acronym}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.0/24"]

}

resource "azurerm_network_interface" "example" {
  name                = "nic-${local.acronym}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                            = "vm-${local.acronym}"
  resource_group_name             = azurerm_resource_group.example.name
  location                        = azurerm_resource_group.example.location
  size                            = "Standard_B1ms"
  admin_username                  = "adminuser"
  admin_password                  = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}


resource "azurerm_public_ip" "example" {
  name                = "pip-${local.acronym}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
  domain_name_label   = "yuryvaskaboinikau"
}


resource "azurerm_network_security_group" "example" {
  name                = "nsg-${local.acronym}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_security_group_id = azurerm_network_security_group.example.id
  network_interface_id      = azurerm_network_interface.example.id
}

resource "null_resource" "install_nginx" {
  triggers = {
    host = azurerm_linux_virtual_machine.example.public_ip_address
  }

  connection {
    type     = "ssh"
    user     = "adminuser"
    password = var.admin_password
    host     = azurerm_linux_virtual_machine.example.public_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }
}
