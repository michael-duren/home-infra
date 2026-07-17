terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.111.0"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://192.168.20.2:8006/"
  api_token = var.proxmox_api_token
  # self signed cert
  insecure = true

  ssh {
    agent    = true
    username = "root"
  }
}

# test directory
resource "proxmox_virtual_environment_pool" "k8s" {
  pool_id = "k8s-cluster"
  comment = "Kubernetes cluster VMs -- managed by Terraform, do not hand-edit"
}
