output "vm_id" {
  description = "VM ID of the template, for clone blocks"
  value       = proxmox_virtual_environment_vm.debian_template.vm_id
}
