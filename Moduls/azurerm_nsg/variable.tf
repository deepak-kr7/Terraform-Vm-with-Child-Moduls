variable "nsg" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    nic_id              = string
    rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}
