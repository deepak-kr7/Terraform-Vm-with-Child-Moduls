variable "app_gateway" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    location             = string
    sku_name             = string
    sku_tier             = string
    capacity             = number
    subnet_id            = string
    public_ip_name       = string
    backend_ip_addresses = list(string)
  }))
}
