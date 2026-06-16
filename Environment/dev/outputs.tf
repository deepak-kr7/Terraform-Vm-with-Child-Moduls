output "resource_group_ids" {
  value = [for rg in module.resource_group.rg_output : rg.id]
}

output "storage_account_ids" {
  value = [for sa in module.storage_account.st_output : sa.id]
}

output "vnet_ids" {
  value = [for vnet in module.vnet.vnet_output : vnet.id]
}

output "vm_ids" {
  value = [for vm in module.vm.vm_output : vm.id]
}

output "bastion_dns_names" {
  value = [for b in module.bastion.bastion_output : b.dns_name]
}

output "lb_ids" {
  value = [for lb in module.lb.lb_output : lb.id]
}
