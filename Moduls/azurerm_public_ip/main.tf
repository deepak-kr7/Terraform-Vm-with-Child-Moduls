resource "azurerm_public_ip" "pip" {
  for_each            = var.public_ips
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

output "public_ip_output" {
  value = azurerm_public_ip.pip
}
