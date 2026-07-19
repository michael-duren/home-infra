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

resource "proxmox_virtual_environment_vm" "k8s_cp_1" {
  name      = "k8s-cp-1"
  node_name = var.control_node_name
  vm_id     = 200
  pool_id   = proxmox_virtual_environment_pool.k8s-control.pool_id

  clone {
    vm_id = module.debian_template_control.vm_id
    full  = true
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 4096
  }

  agent {
    enabled = true # see the gotcha below — Ansible flips this later
  }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.20.3/24"
        gateway = "192.168.20.1"
      }
    }

    user_account {
      username = "ops"
      keys     = [trimspace(file("~/.ssh/id_ed25519.pub"))]
    }
  }
}
