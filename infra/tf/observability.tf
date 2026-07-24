# Observability VMs (Grafana for the k3s cluster) -- live on pve-main with the
# other standalone services, off the cluster they observe.

resource "proxmox_virtual_environment_pool" "observability" {
  pool_id = "observability"
  comment = "Observability VMs -- managed by Terraform, do not hand-edit"
}

module "grafana" {
  source = "./modules/debian-vm"

  name                = "grafana"
  node_name           = var.control_node_name
  vm_id               = 202
  pool_id             = proxmox_virtual_environment_pool.observability.pool_id
  template_vm_id      = module.debian_template_control.vm_id
  vendor_data_file_id = module.debian_template_control.vendor_data_file_id
  ip                  = "192.168.20.5"
  cores               = 2
  memory              = 4096

  providers = {
    proxmox = proxmox
  }
}

# Pools don't span the two standalone Proxmox instances, so the worker node
# needs its own observability pool.
resource "proxmox_virtual_environment_pool" "observability_worker" {
  provider = proxmox.worker
  pool_id  = "observability"
  comment  = "Observability VMs -- managed by Terraform, do not hand-edit"
}

# Prometheus lives on pve-worker next to pgdb; Grafana (pve-main) reads from it.
module "prometheus" {
  source = "./modules/debian-vm"

  name                = "prometheus"
  node_name           = var.worker_node_name
  vm_id               = 206
  pool_id             = proxmox_virtual_environment_pool.observability_worker.pool_id
  template_vm_id      = module.debian_template_worker.vm_id
  vendor_data_file_id = module.debian_template_worker.vendor_data_file_id
  ip                  = "192.168.20.104"
  cores               = 2
  memory              = 4096

  providers = {
    proxmox = proxmox.worker
  }
}
