# 4. Variables & Outputs
variable "cluster_name" {
  type        = string
  description = "Name of the K3s cluster"
}

variable "nodes" {
  type = map(object({
    name        = string
    target_node = string
    vmid        = number
    ip          = string
    cpu_cores   = number
    memory_mb   = number
    disk_size   = number
    template_id = number
  }))
  description = "Configuration for the cluster nodes"
}

variable "gateway" {
  type        = string
  description = "Network gateway"
}

variable "ssh_public_keys" {
  type        = list(string)
  description = "SSH public keys for the VMs"
}

variable "k3s_token" {
  type        = string
  sensitive   = true
  description = "K3s cluster token"
}

variable "target_storage" {
  type        = string
  default     = "ssd-zfs-master"
  description = "Proxmox datastore for disks"
}

variable "network_bridge" {
  type        = string
  default     = "vmbr0"
  description = "Network bridge for the VMs"
}

variable "registry_mirrors" {
  type = map(object({
    endpoints = list(string)
  }))
  default     = {}
  description = "Optional K3s registry mirror configuration keyed by registry hostname"
}
