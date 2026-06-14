variable "bastion" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_id           = string
    public_ip_name      = string
  }))
}
