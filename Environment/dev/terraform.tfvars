rg_map = {
  rg1 = {
    name     = "rg-centralindia"
    location = "centralindia"
  }
  rg2 = {
    name     = "rg-canadacentral"
    location = "canadacentral"
  }
}

vnet_map = {
  vnet1 = {
    name                = "vnet-centralindia"
    address_space       = ["10.1.0.0/16"]
    location            = "centralindia"
    resource_group_name = "rg-centralindia"
  }
  vnet2 = {
    name                = "vnet-canadacentral"
    address_space       = ["10.2.0.0/16"]
    location            = "canadacentral"
    resource_group_name = "rg-canadacentral"
  }
}

subnet_map = {
  subnet1 = {
    name                 = "snet-vm-central"
    resource_group_name  = "rg-centralindia"
    virtual_network_name = "vnet-centralindia"
    address_prefixes     = ["10.1.1.0/24"]
  }
  subnet2 = {
    name                 = "snet-vm-canada"
    resource_group_name  = "rg-canadacentral"
    virtual_network_name = "vnet-canadacentral"
    address_prefixes     = ["10.2.1.0/24"]
  }
  subnet_bastion1 = {
    name                 = "AzureBastionSubnet"
    resource_group_name  = "rg-centralindia"
    virtual_network_name = "vnet-centralindia"
    address_prefixes     = ["10.1.3.0/24"]
  }
  subnet_backend1 = {
    name                 = "snet-backend-central"
    resource_group_name  = "rg-centralindia"
    virtual_network_name = "vnet-centralindia"
    address_prefixes     = ["10.1.4.0/24"]
  }
}

nic_map = {
  nic1 = {
    name                = "nic-vm1"
    location            = "centralindia"
    resource_group_name = "rg-centralindia"
    subnet_key          = "subnet_backend1"
  }
  nic2 = {
    name                = "nic-vm2"
    location            = "canadacentral"
    resource_group_name = "rg-canadacentral"
    subnet_key          = "subnet2"
  }
  nic3 = {
    name                = "nic-vm3"
    location            = "centralindia"
    resource_group_name = "rg-centralindia"
    subnet_key          = "subnet_backend1"
  }
}

vm_map = {
  vm1 = {
    name                = "vm-central"
    location            = "centralindia"
    resource_group_name = "rg-centralindia"
    nic_key             = "nic1"
    vm_size             = "Standard_D2s_v4"
    admin_username      = "adminuser"
    admin_password      = "Password123!"
    custom_data         = null
  }
  vm2 = {
    name                = "vm-canada"
    location            = "canadacentral"
    resource_group_name = "rg-canadacentral"
    nic_key             = "nic2"
    vm_size             = "Standard_D2s_v4"
    admin_username      = "adminuser"
    admin_password      = "Password123!"
    custom_data         = null
  }
  vm3 = {
    name                = "vm-central2"
    location            = "centralindia"
    resource_group_name = "rg-centralindia"
    nic_key             = "nic3"
    vm_size             = "Standard_D2s_v4"
    admin_username      = "adminuser"
    admin_password      = "Password123!"
    custom_data         = null
  }
}

peering_map = {
  peer1 = {
    vnet1_key = "vnet1"
    vnet2_key = "vnet2"
  }
}

bastion_map = {
  bastion1 = {
    name                = "dev-bastion-central"
    location            = "centralindia"
    resource_group_name = "rg-centralindia"
    subnet_key          = "subnet_bastion1"
    public_ip_name      = "pip-bastion-central"
  }
}

nsg_map = {
  nsg1 = {
    name                = "nsg-vm-central"
    location            = "centralindia"
    resource_group_name = "rg-centralindia"
    nic_key             = "nic1"
    rules = [
      {
        name                       = "Allow-SSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-HTTP"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-HTTPS"
        priority                   = 120
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
  nsg2 = {
    name                = "nsg-vm-canada"
    location            = "canadacentral"
    resource_group_name = "rg-canadacentral"
    nic_key             = "nic2"
    rules = [
      {
        name                       = "Allow-SSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-HTTP"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-HTTPS"
        priority                   = 120
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
  nsg3 = {
    name                = "nsg-vm-central2"
    location            = "centralindia"
    resource_group_name = "rg-centralindia"
    nic_key             = "nic3"
    rules = [
      {
        name                       = "Allow-SSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-HTTP"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-HTTPS"
        priority                   = 120
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
}

lb_map = {
  lb1 = {
    name                = "dev-lb-central"
    location            = "centralindia"
    resource_group_name = "rg-centralindia"
    public_ip_name      = "pip-lb-central"
    backend_nic_keys    = ["nic1", "nic3"]
  }
  lb2 = {
    name                = "dev-lb-canada"
    location            = "canadacentral"
    resource_group_name = "rg-canadacentral"
    public_ip_name      = "pip-lb-canada"
    backend_nic_keys    = ["nic2"]
  }
}

nat_gateway_map = {
  nat1 = {
    name                = "dev-nat-central"
    location            = "centralindia"
    resource_group_name = "rg-centralindia"
    public_ip_name      = "pip-nat-central"
    subnet_keys         = ["subnet1", "subnet_backend1"]
  }
  nat2 = {
    name                = "dev-nat-canada"
    location            = "canadacentral"
    resource_group_name = "rg-canadacentral"
    public_ip_name      = "pip-nat-canada"
    subnet_keys         = ["subnet2"]
  }
}

