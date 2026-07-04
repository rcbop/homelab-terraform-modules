resource "proxmox_virtual_environment_vm" "this" {
  name          = var.name
  node_name     = var.target_node
  vm_id         = var.vmid
  tags          = var.tags
  description   = "Managed by Terraform"
  bios          = var.bios
  machine       = var.machine
  protection    = var.protection
  scsi_hardware = var.scsi_hardware

  cpu {
    cores = var.cpu_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.memory_mb
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "ssd-zfs-master"
    interface    = "scsi0"
    size         = var.disk_size
  }

  dynamic "efi_disk" {
    for_each = var.efi_datastore_id != null ? [1] : []
    content {
      datastore_id      = var.efi_datastore_id
      file_format       = "raw"
      pre_enrolled_keys = false
      type              = "4m"
    }
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${var.ip}/24"
        gateway = var.gateway
      }
    }
  }

  dynamic "usb" {
    for_each = var.usb_passthrough
    content {
      host = usb.value.host
    }
  }

  lifecycle {
    prevent_destroy = true # Safety first!
    ignore_changes = [
      network_device,   # Prevents MAC address/bridge changes from forcing replacement
      initialization,   # Prevents cloud-init data from forcing replacement
      vm_id,            # Prevents replacement when ID is explicitly set vs calculated
      operating_system, # Prevents replacement due to OS type mismatch (l26 vs default)
      efi_disk,         # Prevents replacement due to EFI disk detection issues
      bios,             # Prevents replacement due to BIOS type mismatch
      disk,             # Prevents replacement due to disk attribute mismatches
    ]
  }
}
