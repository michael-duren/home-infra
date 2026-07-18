terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.111.0"
    }
  }
}

# default provider: pve-main / control plane node
provider "proxmox" {
  endpoint  = "https://192.168.20.2:8006/"
  api_token = var.proxmox_api_token
  # self signed cert
  insecure = true

  ssh {
    # read the key directly -- the provider can't use ~/.ssh config or key
    # files on its own, and we don't run an ssh-agent
    private_key = file("~/.ssh/id_ed25519")
    username    = "root"
  }
}

// worker provider: worker nodes
provider "proxmox" {
  alias     = "worker"
  endpoint  = "https://192.168.20.100:8006/"
  api_token = var.proxmox_worker_api_token
  insecure  = true

  ssh {
    # read the key directly -- the provider can't use ~/.ssh config or key
    # files on its own, and we don't run an ssh-agent
    private_key = file("~/.ssh/id_ed25519")
    username    = "root"
  }
}
