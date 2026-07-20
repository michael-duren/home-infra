variable "name" {
  description = "VM name (also used as the k8s/ansible hostname)"
  type        = string
}

variable "node_name" {
  description = "Proxmox node to create the VM on"
  type        = string
}

variable "vm_id" {
  description = "VM ID (each Proxmox instance has its own ID space)"
  type        = number
}

variable "pool_id" {
  description = "Resource pool to place the VM in"
  type        = string
}

variable "template_vm_id" {
  description = "VM ID of the debian-template to clone"
  type        = number
}

variable "vendor_data_file_id" {
  description = "Cloud-init vendor-data snippet id (installs qemu-guest-agent on first boot)"
  type        = string
}

variable "ip" {
  description = "Static IPv4 address, without prefix length"
  type        = string
}

variable "prefix_length" {
  description = "IPv4 prefix length for the server subnet"
  type        = number
  default     = 24
}

variable "gateway" {
  description = "IPv4 gateway (the server-network router)"
  type        = string
  default     = "192.168.20.1"
}

variable "cores" {
  description = "CPU cores"
  type        = number
}

variable "memory" {
  description = "Dedicated memory in MiB"
  type        = number
}

variable "disk_size" {
  description = "OS disk size in GiB"
  type        = number
  default     = 40
}

variable "datastore_id" {
  description = "Datastore for the OS disk"
  type        = string
  default     = "local-lvm"
}

variable "username" {
  description = "Cloud-init user account"
  type        = string
  default     = "ops"
}

variable "ssh_public_key_file" {
  description = "Public key file for the cloud-init user"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "passthrough_disks" {
  description = "Host block device paths (/dev/disk/by-id/...) to attach as extra virtio disks"
  type        = list(string)
  default     = []
}
