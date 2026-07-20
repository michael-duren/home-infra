resource "proxmox_virtual_environment_pool" "databases" {
  provider = proxmox.worker
  pool_id  = "databases"
  comment  = "Database VMs -- managed by Terraform, do not hand-edit"
}

module "pgdb" {
  source = "./modules/debian-vm"

  name                = var.dbname
  node_name           = var.worker_node_name
  vm_id               = 205
  pool_id             = proxmox_virtual_environment_pool.databases.pool_id
  template_vm_id      = module.debian_template_worker.vm_id
  vendor_data_file_id = module.debian_template_worker.vendor_data_file_id
  ip                  = "192.168.20.103"
  cores               = 4
  memory              = 8192

  providers = {
    proxmox = proxmox.worker
  }
}

moved {
  from = proxmox_virtual_environment_vm.pgdb
  to   = module.pgdb.proxmox_virtual_environment_vm.this
}
