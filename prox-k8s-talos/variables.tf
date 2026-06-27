variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string
  default     = "talos-homelab"
}

variable "cluster_endpoint" {
  description = "Public endpoint of the Talos cluster"
  type        = string
}

variable "talos_version" {
  description = "Talos version to install"
  type        = string
  default     = "v1.12.6"
}

variable "network_bridge" {
  description = "Proxmox network bridge for the VMs"
  type        = string
  default     = "vmbr0"
}

variable "node_region" {
  description = "Kubernetes topology region label applied to Talos nodes"
  type        = string
  default     = "default"
}

variable "network_gateway" {
  description = "Default gateway for Talos node networking"
  type        = string
}

variable "nameservers" {
  description = "DNS nameservers for Talos node networking"
  type        = list(string)
  default     = ["1.1.1.1"]
}

variable "control_plane_vip" {
  description = "Optional virtual IP assigned to the control plane interface"
  type        = string
  default     = null
}

variable "longhorn_disk_ssh_user" {
  description = "SSH user used by the optional Longhorn disk attachment helper"
  type        = string
  default     = "root"
}

variable "proxmox_node_domain" {
  description = "Optional DNS suffix used to derive Proxmox node hostnames for Longhorn disk attachment"
  type        = string
  default     = null
}

variable "target_storage" {
  description = "Proxmox storage pool for the VM disks"
  type        = string
  default     = "ssd-zfs-master"
}

variable "control_plane_nodes" {
  description = "Map of control plane node configurations"
  type = map(object({
    name           = string
    target_node    = string
    vmid           = number
    ip             = string
    cpu_cores      = number
    memory_mb      = number
    disk_size      = number
    qemu_agent     = bool
    mount_cni      = optional(bool, false)
    interface_name = optional(string, "eth0")
    vip_enabled    = optional(bool, true)
    storage        = optional(string)
  }))
}

variable "worker_nodes" {
  description = "Map of worker node configurations"
  type = map(object({
    name           = string
    target_node    = string
    vmid           = number
    ip             = string
    cpu_cores      = number
    memory_mb      = number
    balloon_mb     = optional(number, 0)
    disk_size      = number
    qemu_agent     = bool
    mount_cni      = optional(bool, false)
    interface_name = optional(string, "eth0")
    longhorn_data_disk = optional(object({
      enabled  = optional(bool, false)
      size_gb  = number
      slot     = optional(number, 20)
      storage  = optional(string)
      serial   = optional(string)
      host     = optional(string)
      min_size = optional(string, "200GB")
      max_size = optional(string, "250GB")
    }))
    pci_devices = optional(list(object({
      device  = optional(string)
      mapping = optional(string)
      pcie    = bool
      mdev    = optional(string)
    })), [])
    vga = optional(object({
      type   = optional(string, "std")
      memory = optional(number, 16)
    }))
  }))
}

variable "registry_mirrors" {
  description = "Map of registry mirrors"
  type        = any
  default     = {}
}
