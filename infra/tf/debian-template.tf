resource "proxmox_virtual_environment_vm" "k8s_cp_1" {
  name = "k8s-cp-1"
  # your node name from the installer
  node_name = "touchgrass"
  vm_id     = 200
  pool_id   = proxmox_virtual_environment_pool.k8s.pool_id

  clone {
    vm_id = 9000
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
