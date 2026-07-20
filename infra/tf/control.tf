# Proxmox node 1 (pve-main, 192.168.20.2) -- services + k8s control plane.
# Uses the default provider.

module "debian_template_control" {
  source    = "./modules/debian-template"
  node_name = var.control_node_name

  providers = {
    proxmox = proxmox
  }
}

resource "proxmox_virtual_environment_pool" "k8-control" {
  pool_id = "k8s-control-nodes"
  comment = "Kubernetes cluster control VMs -- managed by Terraform, do not hand-edit"
}

module "k8s_cp_1" {
  source = "./modules/debian-vm"

  name                = "k8s-cp-1"
  node_name           = var.control_node_name
  vm_id               = 200
  pool_id             = proxmox_virtual_environment_pool.k8-control.pool_id
  template_vm_id      = module.debian_template_control.vm_id
  vendor_data_file_id = module.debian_template_control.vendor_data_file_id
  ip                  = "192.168.20.3"
  cores               = 2
  memory              = 4096

  providers = {
    proxmox = proxmox
  }
}

moved {
  from = proxmox_virtual_environment_vm.k8s_cp_1
  to   = module.k8s_cp_1.proxmox_virtual_environment_vm.this
}

resource "proxmox_virtual_environment_pool" "media" {
  pool_id = "media"
  comment = "Media server VMs -- managed by Terraform, do not hand-edit"
}

module "jellyfin" {
  source = "./modules/debian-vm"

  name                = "jellyfin"
  node_name           = var.control_node_name
  vm_id               = 201
  pool_id             = proxmox_virtual_environment_pool.media.pool_id
  template_vm_id      = module.debian_template_control.vm_id
  vendor_data_file_id = module.debian_template_control.vendor_data_file_id
  ip                  = "192.168.20.4"
  cores               = 4
  memory              = 8192
  passthrough_disks   = [var.media_disk_path]

  # root alias: host disk passthrough is refused for token-authenticated API
  # calls, see main.tf
  providers = {
    proxmox = proxmox.root
  }
}
