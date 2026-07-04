terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "storageterrastate123"
    container_name       = "tfstate"
    key                  = "sample.tfstate"
  }
}

provider "azurerm" {
  features {}
}