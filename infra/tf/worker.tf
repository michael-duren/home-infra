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

resource "proxmox_virtual_environment_vm" "worker" {
  for_each = local.workers

  provider  = proxmox.worker
  name      = each.key
  node_name = var.worker_node_name
  vm_id     = each.value.vm_id
  pool_id   = proxmox_virtual_environment_pool.k8-workers.pool_id

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
    enabled = true
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = "192.168.20.1"
      }
    }

    user_account {
      username = "ops"
      keys     = [trimspace(file("~/.ssh/id_ed25519.pub"))]
    }
  }
}
