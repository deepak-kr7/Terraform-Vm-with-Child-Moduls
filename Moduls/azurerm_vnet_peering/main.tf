resource "azurerm_virtual_network_peering" "peer1to2" {
  for_each                  = var.peering
  name                      = "${each.value.vnet1_name}-to-${each.value.vnet2_name}"
  resource_group_name       = each.value.vnet1_rg
  virtual_network_name      = each.value.vnet1_name
  remote_virtual_network_id = each.value.vnet2_id
}

resource "azurerm_virtual_network_peering" "peer2to1" {
  for_each                  = var.peering
  name                      = "${each.value.vnet2_name}-to-${each.value.vnet1_name}"
  resource_group_name       = each.value.vnet2_rg
  virtual_network_name      = each.value.vnet2_name
  remote_virtual_network_id = each.value.vnet1_id
}
