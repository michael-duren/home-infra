variable "proxmox_api_token" {
  description = "Proxmox API token in user@realm!id=secret form"
  type        = string
  sensitive   = true
}
