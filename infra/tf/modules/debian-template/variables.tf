variable "node_name" {
  description = "Proxmox node to create the template on"
  type        = string
}

variable "vm_id" {
  description = "VM ID for the template (each Proxmox instance has its own ID space)"
  type        = number
  default     = 9000
}

variable "datastore_id" {
  description = "Datastore for the template's disk and cloud-init drive"
  type        = string
  default     = "local-lvm"
}

variable "image_datastore_id" {
  description = "Datastore the cloud image gets downloaded to (must allow file storage)"
  type        = string
  default     = "local"
}

variable "image_url" {
  description = "URL of the Debian cloud image (qcow2)"
  type        = string
  default     = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
}
