terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.113.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-github-actions-state"
    storage_account_name = "terraformghactionsvya01"
    container_name       = "tfstate"
    key                  = "terraform-lab-4.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {}
}

provider "null" {
  # Configuration options
}
