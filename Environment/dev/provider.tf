terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}
resource "random_string" "random1" {
  length  = 2
  special = false
  upper   = false
}