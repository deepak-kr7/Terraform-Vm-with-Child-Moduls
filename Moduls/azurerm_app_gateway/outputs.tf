output "appgw_public_ip" {
  value = { for k, v in azurerm_public_ip.appgw_pip : k => v.ip_address }
}
