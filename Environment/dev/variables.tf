variable "rg_map" {
  type = map(object({
    name     = string
    location = string
  }))
}

variable "storage_account_map" {
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string
  }))
}

variable "storage_container_map" {
  type = map(object({
    name                  = string
    storage_account_key   = string # Reference to storage_account_map key
    container_access_type = string
  }))
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
    subnet_key          = string # Using key to reference subnet
  }))
}

variable "nsg_map" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    nic_key             = string # Using key to reference nic
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

variable "vm_map" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    nic_key             = string # Using key to reference nic
    vm_size             = string
    admin_username      = string
    admin_password      = string
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
}
