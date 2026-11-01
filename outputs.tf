
output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "management_subnet_id" {
  value = azurerm_subnet.management.id
}

output "workload_subnet_id" {
  value = azurerm_subnet.workload.id
}


output "vm_private_ip" {
  description = "Private IP address of Ubuntu VM"
  value       = azurerm_network_interface.vm.private_ip_address
}

output "vm_name" {
  description = "Name of Ubuntu VM"
  value       = azurerm_linux_virtual_machine.vm.name
}


output "vm_public_ip" {
  description = "Public IP address of Ubuntu VM"
  value       = azurerm_public_ip.vm.ip_address
}
