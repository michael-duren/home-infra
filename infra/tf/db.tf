resource "proxmox_virtual_environment_pool" "databases" {
  provider = proxmox.worker
  pool_id  = "databases"
  comment  = "Database VMs -- managed by Terraform, do not hand-edit"
}

resource "proxmox_virtual_environment_vm" "pgdb" {
  name      = var.dbname
  node_name = var.worker_node_name
  vm_id     = 205
  provider  = proxmox.worker
  pool_id   = proxmox_virtual_environment_pool.databases.pool_id

  clone {
    vm_id = module.debian_template_worker.vm_id
    full  = true
  }

  cpu {
    cores = 4
    type  = "host"
  }

  memory {
    dedicated = 8192
  }

  agent {
    enabled = true # agent device is attached; the playbooks install the guest package
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio0"
    discard      = "on"
    size         = 40
  }

  initialization {
    vendor_data_file_id = module.debian_template_worker.vendor_data_file_id

    ip_config {
      ipv4 {
        address = "192.168.20.103/24"
        gateway = "192.168.20.1"
      }
    }

    user_account {
      username = "ops"
      keys     = [trimspace(file("~/.ssh/id_ed25519.pub"))]
    }
  }
}
