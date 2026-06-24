resource "azurerm_public_ip" "nat_pip" {
  for_each            = var.nat_gateways
  name                = each.value.public_ip_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "nat" {
  for_each            = var.nat_gateways
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_assoc" {
  for_each             = var.nat_gateways
  nat_gateway_id       = azurerm_nat_gateway.nat[each.key].id
  public_ip_address_id = azurerm_public_ip.nat_pip[each.key].id
}

# Flatten the association to handle multiple subnets per NAT Gateway
locals {
  nat_subnet_associations = flatten([
    for nat_key, nat_val in var.nat_gateways : [
      for subnet_id in nat_val.subnet_ids : {
        nat_key   = nat_key
        subnet_id = subnet_id
      }
    ]
  ])
}

resource "azurerm_subnet_nat_gateway_association" "nat_sub_assoc" {
  count          = length(local.nat_subnet_associations)
  subnet_id      = local.nat_subnet_associations[count.index].subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat[local.nat_subnet_associations[count.index].nat_key].id
}
