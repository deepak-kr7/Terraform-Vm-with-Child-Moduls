variable "nat_gateways" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    public_ip_name      = string
    subnet_ids          = list(string)
  }))
}
