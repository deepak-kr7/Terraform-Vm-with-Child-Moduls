module "resource_group" {
  source = "../../Moduls/azurerm_resource_group"
  rg     = var.rg_map
}

module "storage_account" {
  source           = "../../Moduls/azurerm_storage_account"
  storage_accounts = {
    for k, v in var.storage_account_map : k => {
      name                     = "${v.name}${random_string.random1.result}"
      resource_group_name      = v.resource_group_name
      location                 = v.location
      account_tier             = v.account_tier
      account_replication_type = v.account_replication_type
    }
  }
  depends_on       = [module.resource_group]
}

module "storage_container" {
  source = "../../Moduls/azurerm_storage_container"
  containers = {
    for k, v in var.storage_container_map : k => {
      name                  = "${v.name}${random_string.random1.result}"
      storage_account_id    = module.storage_account.st_output[v.storage_account_key].id
      container_access_type = v.container_access_type
    }
  }
}

module "vnet" {
  source     = "../../Moduls/azurerm_vnet"
  vnet       = var.vnet_map
  depends_on = [module.resource_group]
}

module "subnet" {
  source     = "../../Moduls/azurerm_subnet"
  subnet     = var.subnet_map
  depends_on = [module.vnet]
}

module "nic" {
  source = "../../Moduls/azurerm_nic"
  nic = {
    for k, v in var.nic_map : k => {
      name                = v.name
      location            = v.location
      resource_group_name = v.resource_group_name
      subnet_id           = module.subnet.subnet_output[v.subnet_key].id
    }
  }
}

module "nsg" {
  source = "../../Moduls/azurerm_nsg"
  nsg = {
    for k, v in var.nsg_map : k => {
      name                = v.name
      location            = v.location
      resource_group_name = v.resource_group_name
      nic_id              = module.nic.nic_output[v.nic_key].id
      rules               = v.rules
    }
  }
}

module "vm" {
  source = "../../Moduls/azurerm_vm"
  vm = {
    for k, v in var.vm_map : k => {
      name                = v.name
      location            = v.location
      resource_group_name = v.resource_group_name
      nic_id              = module.nic.nic_output[v.nic_key].id
      vm_size             = v.vm_size
      admin_username      = v.admin_username
      admin_password      = v.admin_password
    }
  }
}

module "vnet_peering" {
  source = "../../Moduls/azurerm_vnet_peering"
  peering = {
    for k, v in var.peering_map : k => {
      vnet1_name = module.vnet.vnet_output[v.vnet1_key].name
      vnet1_rg   = module.vnet.vnet_output[v.vnet1_key].resource_group_name
      vnet1_id   = module.vnet.vnet_output[v.vnet1_key].id
      vnet2_name = module.vnet.vnet_output[v.vnet2_key].name
      vnet2_rg   = module.vnet.vnet_output[v.vnet2_key].resource_group_name
      vnet2_id   = module.vnet.vnet_output[v.vnet2_key].id
    }
  }
}

module "bastion" {
  source = "../../Moduls/azurerm_bastion"
  bastion = {
    for k, v in var.bastion_map : k => {
      name                = v.name
      location            = v.location
      resource_group_name = v.resource_group_name
      subnet_id           = module.subnet.subnet_output[v.subnet_key].id
      public_ip_name      = v.public_ip_name
    }
  }
}
