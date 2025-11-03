terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.51"
    }
  }
}

provider "azurerm" {
  features {}
}
