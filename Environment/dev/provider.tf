terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {
   resource_resource_group_name = "deep_rg" 
    storage_account_name = "deepstg074"                              
    container_name       = "democontainer1"                              
    key                  = "firstcicd.tfstate"          
  }
}



provider "azurerm" {
  features {}
  subscription_id = "5b03e105-f606-436a-ab99-e33ae06a3230"
}
resource "random_string" "random1" {
  length  = 2
  special = false
  upper   = false
}