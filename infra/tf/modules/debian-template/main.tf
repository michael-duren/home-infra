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

# Debian cloud images don't ship qemu-guest-agent, but the bpg provider blocks
# on the agent whenever a VM has agent.enabled=true. This vendor-data snippet
# makes every clone install and start the agent on first boot, so fresh
# rebuilds work without a manual install + cold-restart dance. Composes with
# the clones' user_account/ip_config (only user_data would conflict).
resource "proxmox_virtual_environment_file" "vendor_data" {
  node_name    = var.node_name
  datastore_id = var.image_datastore_id
  content_type = "snippets"

  source_raw {
    file_name = "debian-qemu-agent-vendor.yaml"
    data      = <<-EOF
      #cloud-config
      packages:
        - qemu-guest-agent
      runcmd:
        - systemctl enable --now qemu-guest-agent
    EOF
  }
}

resource "proxmox_virtual_environment_vm" "debian_template" {
  # templates never boot, so the provider can never learn these agent-reported
  # values -- without this, every plan shows a perpetual no-op update
  lifecycle {
    ignore_changes = [ipv4_addresses, ipv6_addresses, network_interface_names]
  }

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
    # templates use a base disk that can't be resized in place; clones override
    # this via their own disk block (see control.tf / worker.tf)
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
