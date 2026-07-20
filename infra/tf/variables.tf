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

variable "dbname" {
  description = "Postgres DB Name"
  type        = string
  default     = "pgdb"
}

variable "proxmox_root_password" {
  description = "root@pam password for pve-main -- needed only for host disk passthrough, which Proxmox refuses for token auth"
  type        = string
  sensitive   = true
}

variable "media_disk_path" {
  description = "Stable by-id path of the external media drive on pve-main, passed whole to the jellyfin VM"
  type        = string
  default     = "/dev/disk/by-id/usb-Samsung_PSSD_T7_Touch_S5KENJ0N600335M-0:0"
}
