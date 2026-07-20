output "vm_id" {
  description = "VM ID of the created VM"
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "ip" {
  description = "Static IPv4 address (without prefix), for inventory/reference"
  value       = var.ip
}
