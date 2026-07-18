terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_download_file" "debian_cloud_image" {
  node_name    = var.node_name
  datastore_id = var.image_datastore_id
  content_type = "iso"
  url          = var.image_url
  # the provider only accepts .img/.iso extensions; the qcow2 boots fine renamed
  file_name = "debian-12-generic-amd64.img"
}

resource "proxmox_virtual_environment_vm" "debian_template" {
  name        = "debian-12-template"
  description = "Debian 12 cloud-init template -- managed by Terraform, do not hand-edit"
  node_name   = var.node_name
  vm_id       = var.vm_id
  template    = true

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  disk {
    datastore_id = var.datastore_id
    file_id      = proxmox_download_file.debian_cloud_image.id
    interface    = "virtio0"
    discard      = "on"
    size         = 20
  }

  network_device {
    bridge = "vmbr0"
  }

  # debian cloud images log to the serial console
  serial_device {}

  # cloud-init drive; clones override ip_config/user_account
  initialization {
    datastore_id = var.datastore_id

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
}
