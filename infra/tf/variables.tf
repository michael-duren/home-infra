variable "proxmox_api_token" {
  description = "Proxmox API token in user@realm!id=secret form"
  type        = string
  sensitive   = true
}

variable "proxmox_worker_api_token" {
  description = "Proxmox API for worker token in user@realm!id=secret form"
  type        = string
  sensitive   = true
}

variable "control_node_name" {
  description = "Proxmox node name of the control node (pve-main)"
  type        = string
  default     = "touchgrass"
}

variable "worker_node_name" {
  description = "Proxmox node name of the worker node (pve-worker)"
  type        = string
  default     = "touchgrassworkers"
}
