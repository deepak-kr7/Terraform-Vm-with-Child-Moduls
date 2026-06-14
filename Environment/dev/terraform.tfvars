rg_map = {
  rg1 = {
    name     = "dev-rg"
    location = "Central India"
  }
}

storage_account_map = {
  sa1 = {
    name                     = "devstgdeep"
    resource_group_name      = "dev-rg"
    location                 = "Central India"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

storage_container_map = {
  c1 = {
    name                  = "dev-container"
    storage_account_key   = "sa1"
    container_access_type = "private"
  }
}

vnet_map = {
  vnet1 = {
    name                = "dev-vnet"
    address_space       = ["10.20.0.0/16"]
    location            = "Central India"
    resource_group_name = "dev-rg"
  }
}

subnet_map = {
  subnet1 = {
    name                 = "dev-subnet"
    resource_group_name  = "dev-rg"
    virtual_network_name = "dev-vnet"
    address_prefixes     = ["10.20.1.0/24"]
  },
  bastion_subnet = {
    name                 = "AzureBastionSubnet"
    resource_group_name  = "dev-rg"
    virtual_network_name = "dev-vnet"
    address_prefixes     = ["10.20.2.0/24"]
  }
}

nic_map = {
  nic1 = {
    name                = "dev-nic"
    location            = "Central India"
    resource_group_name = "dev-rg"
    subnet_key          = "subnet1"
  }
}

nsg_map = {
  nsg1 = {
    name                = "dev-nsg"
    location            = "Central India"
    resource_group_name = "dev-rg"
    nic_key             = "nic1"
    rules = [
      {
        name                       = "SSH"
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
        name                       = "HTTP"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
}

vm_map = {
  vm1 = {
    name                = "dev-vm"
    location            = "Central India"
    resource_group_name = "dev-rg"
    nic_key             = "nic1"
    vm_size             = "Standard_D2s_v3"
    admin_username      = "adminuser"
    admin_password      = "Password123"
  }
}

peering_map = {}

bastion_map = {
  bastion1 = {
    name                = "dev-bastion"
    location            = "Central India"
    resource_group_name = "dev-rg"
    subnet_key          = "bastion_subnet"
    public_ip_name      = "dev-bastion-pip"
  }
}
