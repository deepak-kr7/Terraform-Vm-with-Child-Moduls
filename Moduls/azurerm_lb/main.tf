resource "azurerm_public_ip" "lb_pip" {
  for_each            = var.lb
  name                = each.value.public_ip_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "main" {
  for_each            = var.lb
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip[each.key].id
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  for_each        = var.lb
  loadbalancer_id = azurerm_lb.main[each.key].id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "main" {
  for_each        = var.lb
  loadbalancer_id = azurerm_lb.main[each.key].id
  name            = "http-probe"
  port            = 80
}

resource "azurerm_lb_rule" "main" {
  for_each                       = var.lb
  loadbalancer_id                = azurerm_lb.main[each.key].id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main[each.key].id]
  probe_id                       = azurerm_lb_probe.main[each.key].id
}

# We need to flatten the association to handle multiple NICs per LB
locals {
  lb_nic_associations = flatten([
    for lb_key, lb_val in var.lb : [
      for nic_id in lb_val.backend_nics : {
        lb_key = lb_key
        nic_id = nic_id
      }
    ]
  ])
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = length(local.lb_nic_associations)
  network_interface_id    = local.lb_nic_associations[count.index].nic_id
  ip_configuration_name   = "internal" # This must match the name in azurerm_network_interface
  backend_address_pool_id = azurerm_lb_backend_address_pool.main[local.lb_nic_associations[count.index].lb_key].id
}
