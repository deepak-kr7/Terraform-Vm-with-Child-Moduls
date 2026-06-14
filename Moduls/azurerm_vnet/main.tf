resource "azurerm_virtual_network" "main" {
  for_each            = var.vnet
  name                = each.value.name
  address_space       = each.value.address_space
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}

output "vnet_output" {
  value = azurerm_virtual_network.main
}
