output "vm_id" {
  description = "VM ID of the template, for clone blocks"
  value       = proxmox_virtual_environment_vm.debian_template.vm_id
}

output "vendor_data_file_id" {
  description = "Snippet file id for clones' initialization.vendor_data_file_id"
  value       = proxmox_virtual_environment_file.vendor_data.id
}
