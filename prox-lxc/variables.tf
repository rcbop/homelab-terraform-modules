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
variable "unprivileged" {
  type    = bool
  default = true
}
variable "template_file_id" {
  type = string
}
variable "mount_points" {
  type = list(object({
    volume = string
    path   = string
    size   = string
  }))
  default = []
}
variable "ssh_public_keys" {
  type    = list(string)
  default = []
}

# End of variables
