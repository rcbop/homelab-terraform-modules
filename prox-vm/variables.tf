variable "name" {
  type = string
}
variable "target_node" {
  type = string
}
variable "vmid" {
  type = number
}
variable "memory_mb" {
  type = number
}
variable "cpu_cores" {
  type = number
}
variable "disk_size" {
  type = number
}
variable "ip" {
  type = string
}
variable "gateway" {
  type = string
}
variable "tags" {
  type    = list(string)
  default = []
}
variable "usb_passthrough" {
  type = list(object({
    host = string
  }))
  default = []
}
variable "bios" {
  type    = string
  default = "seabios"
}
variable "efi_datastore_id" {
  type    = string
  default = null
}

# End of variables
