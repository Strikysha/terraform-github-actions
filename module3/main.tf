terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.113.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  acronym = "yury-lab-04"
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

resource "azurerm_subnet" "example_public" {
  name                 = "subnet-public-${local.acronym}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]

}

resource "azurerm_subnet" "example_private" {
  name                 = "subnet-private-${local.acronym}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.0/24"]

}

resource "azurerm_storage_account" "example" {
  name                     = "st${replace(local.acronym, "-", "")}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
