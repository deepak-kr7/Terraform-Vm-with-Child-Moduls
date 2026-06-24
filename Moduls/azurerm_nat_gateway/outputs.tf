output "nat_public_ips" {
  value = { for k, pip in azurerm_public_ip.nat_pip : k => pip.ip_address }
}
