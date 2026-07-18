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
