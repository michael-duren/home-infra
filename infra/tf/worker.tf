# Proxmox node 2 (pve-worker, 192.168.20.100) -- k8s worker VMs.
# Everything here must set provider = proxmox.worker (resources) or
# providers = { proxmox = proxmox.worker } (modules).

module "debian_template_worker" {
  source    = "./modules/debian-template"
  node_name = var.worker_node_name

  providers = {
    proxmox = proxmox.worker
  }
}

locals {
  workers = {
    "k8s-w-1" = { vm_id = 210, ip = "192.168.20.101" }
    "k8s-w-2" = { vm_id = 211, ip = "192.168.20.102" }
  }
}

resource "proxmox_virtual_environment_pool" "k8-workers" {
  provider = proxmox.worker
  pool_id  = "k8s-worker-nodes"
  comment  = "Kubernetes cluster worker VMs -- managed by Terraform, do not hand-edit"
}

module "worker" {
  source   = "./modules/debian-vm"
  for_each = local.workers

  name                = each.key
  node_name           = var.worker_node_name
  vm_id               = each.value.vm_id
  pool_id             = proxmox_virtual_environment_pool.k8-workers.pool_id
  template_vm_id      = module.debian_template_worker.vm_id
  vendor_data_file_id = module.debian_template_worker.vendor_data_file_id
  ip                  = each.value.ip
  cores               = 4
  memory              = 8192

  providers = {
    proxmox = proxmox.worker
  }
}

moved {
  from = proxmox_virtual_environment_vm.worker["k8s-w-1"]
  to   = module.worker["k8s-w-1"].proxmox_virtual_environment_vm.this
}

moved {
  from = proxmox_virtual_environment_vm.worker["k8s-w-2"]
  to   = module.worker["k8s-w-2"].proxmox_virtual_environment_vm.this
}
