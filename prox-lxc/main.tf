resource "proxmox_virtual_environment_container" "this" {
  node_name = var.target_node
  vm_id     = var.vmid
  tags      = var.tags

  initialization {
    hostname = var.name
    ip_config {
      ipv4 {
        address = "${var.ip}/32"
        gateway = var.gateway
      }
    }
    user_account {
      keys = var.ssh_public_keys
    }
  }

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory_mb
  }

  operating_system {
    template_file_id = var.template_file_id
    type             = "debian"
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "ssd-zfs-master"
    size         = 8
  }

  dynamic "mount_point" {
    for_each = var.mount_points
    content {
      volume = mount_point.value.volume
      path   = mount_point.value.path
      size   = mount_point.value.size
    }
  }

  unprivileged  = var.unprivileged
  start_on_boot = true
  started       = true

  lifecycle {
    prevent_destroy = false # Temporarily disabled for decommissioning
    ignore_changes = [
      operating_system,  # Prevents replacement of existing CTs with null/differing template IDs
      unprivileged,      # Prevents replacement of legacy CTs
      vm_id,             # Prevents replacement when matching existing ID but seen as "newly set"
      mount_point,       # Prevents permission check failures for existing bind mounts
      disk,              # Prevents replacement due to disk attribute mismatches
      network_interface, # Prevents replacement due to interface attribute mismatches
      initialization,    # Prevents replacement due to SSH key injection or hostname changes
    ]
  }
}
