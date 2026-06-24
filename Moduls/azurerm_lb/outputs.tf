output "lb_output" {
  value = azurerm_lb.main
}

output "lb_public_ips" {
  value = { for k, pip in azurerm_public_ip.lb_pip : k => pip.ip_address }
}
