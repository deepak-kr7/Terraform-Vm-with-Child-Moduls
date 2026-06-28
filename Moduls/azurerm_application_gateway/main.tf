resource "azurerm_public_ip" "appgw_pip" {
  for_each            = var.app_gateways
  name                = each.value.public_ip_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "network" {
  for_each            = var.app_gateways
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  sku {
    name     = each.value.sku_name
    tier     = each.value.sku_tier
    capacity = each.value.capacity
  }

  gateway_ip_configuration {
    name      = "${each.value.name}-gwip"
    subnet_id = each.value.subnet_id
  }

  frontend_port {
    name = "${each.value.name}-feport"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "${each.value.name}-feip"
    public_ip_address_id = azurerm_public_ip.appgw_pip[each.key].id
  }

  backend_address_pool {
    name = "${each.value.name}-beap"
  }

  backend_http_settings {
    name                  = "${each.value.name}-be-htst"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "${each.value.name}-httplstn"
    frontend_ip_configuration_name = "${each.value.name}-feip"
    frontend_port_name             = "${each.value.name}-feport"
    protocol                       = "Http"
    host_name                      = each.value.host_name
  }

  request_routing_rule {
    name                       = "${each.value.name}-rtr"
    rule_type                  = "Basic"
    http_listener_name         = "${each.value.name}-httplstn"
    backend_address_pool_name  = "${each.value.name}-beap"
    backend_http_settings_name = "${each.value.name}-be-htst"
    priority                   = 100
  }
}

locals {
  appgw_nic_associations = flatten([
    for gw_key, gw_val in var.app_gateways : [
      for nic_id in gw_val.backend_nics : {
        gw_key = gw_key
        nic_id = nic_id
      }
    ]
  ])
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "association" {
  count                   = length(local.appgw_nic_associations)
  network_interface_id    = local.appgw_nic_associations[count.index].nic_id
  ip_configuration_name   = "internal"
  backend_address_pool_id = tolist(azurerm_application_gateway.network[local.appgw_nic_associations[count.index].gw_key].backend_address_pool)[0].id
}

output "app_gateway_public_ips" {
  value = { for k, v in azurerm_public_ip.appgw_pip : k => v.ip_address }
}

