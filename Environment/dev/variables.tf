variable "rg_map" {
  type = map(object({
    name     = string
    location = string
  }))
}

variable "public_ip_map" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
  }))
  default = {}
}

variable "storage_account_map" {
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string
  }))
  default = {}
}

variable "storage_container_map" {
  type = map(object({
    name                  = string
    storage_account_key   = string
    container_access_type = string
  }))
  default = {}
}

variable "vnet_map" {
  type = map(object({
    name                = string
    address_space       = list(string)
    location            = string
    resource_group_name = string
  }))
}

variable "subnet_map" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
  }))
}

variable "nic_map" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_key          = string
    public_ip_key       = optional(string)
  }))
}

variable "nsg_map" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    nic_key             = string
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
  default = {}
}

variable "vm_map" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    nic_key             = string
    vm_size             = string
    admin_username      = string
    admin_password      = string
    custom_data         = optional(string)
  }))
}

variable "peering_map" {
  type = map(object({
    vnet1_key = string
    vnet2_key = string
  }))
}

variable "bastion_map" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_key          = string
    public_ip_name      = string
  }))
  default = {}
}

variable "lb_map" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    public_ip_name      = string
    backend_nic_keys    = list(string)
  }))
  default = {}
}

variable "app_gateway_map" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku_name            = string
    sku_tier            = string
    capacity            = number
    subnet_key          = string
    public_ip_name      = string
    backend_nic_keys    = list(string)
  }))
  default = {}
}

variable "frontdoor_map" {
  type = map(object({
    name                = string
    resource_group_name = string
    origins             = map(string)
  }))
  default = {}
}

variable "nat_gateway_map" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    public_ip_name      = string
    subnet_keys         = list(string)
  }))
  default = {}
}
