terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  name      = var.name
  node_name = var.node_name
  vm_id     = var.vm_id
  pool_id   = var.pool_id

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  # full clones get their own resizable disk (the template's base disk can't be
  # resized in place); sized up for k3s images + container storage
  disk {
    datastore_id = var.datastore_id
    interface    = "virtio0"
    discard      = "on"
    size         = var.disk_size
  }

  # host block devices (e.g. the external media drive), attached whole --
  # excluded from vzdump backups since they're not on a Proxmox datastore
  dynamic "disk" {
    for_each = var.passthrough_disks
    content {
      datastore_id      = ""
      path_in_datastore = disk.value
      interface         = "virtio${disk.key + 1}"
      file_format       = "raw"
      backup            = false
    }
  }

  cpu {
    cores = var.cores
    type  = "host"
  }

  memory {
    dedicated = var.memory
  }

  agent {
    enabled = true # the template's vendor-data installs the guest agent on first boot
  }

  initialization {
    vendor_data_file_id = var.vendor_data_file_id

    ip_config {
      ipv4 {
        address = "${var.ip}/${var.prefix_length}"
        gateway = var.gateway
      }
    }

    user_account {
      username = var.username
      keys     = [trimspace(file(var.ssh_public_key_file))]
    }
  }
}
