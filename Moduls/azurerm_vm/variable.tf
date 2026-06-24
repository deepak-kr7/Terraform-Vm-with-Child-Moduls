variable "vm" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    nic_id              = string
    vm_size             = string
    admin_username      = string
    admin_password      = string
    custom_data         = optional(string)
  }))
}
