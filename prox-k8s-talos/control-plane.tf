resource "proxmox_virtual_environment_vm" "talos_control_plane" {
  for_each = var.control_plane_nodes

  name        = each.value.name
  description = "Talos Linux Control Plane"
  node_name   = each.value.target_node
  tags        = ["control-plane", "homelab", "k8s"]
  vm_id       = each.value.vmid

  boot_order = ["scsi0"]
  on_boot    = true
  started    = true

  agent {
    enabled = each.value.qemu_agent
  }

  cpu {
    cores = each.value.cpu_cores
    type  = "host"
  }

  memory {
    dedicated = each.value.memory_mb
  }

  disk {
    datastore_id = coalesce(try(each.value.storage, null), var.target_storage)
    file_id      = proxmox_virtual_environment_download_file.talos_nocloud_image.id
    file_format  = "raw"
    interface    = "scsi0"
    size         = each.value.disk_size
    discard      = "on"
    ssd          = true
    serial       = substr(upper(each.value.name), 0, 20)
  }

  network_device {
    bridge = var.network_bridge
  }

  bios = "ovmf"

  efi_disk {
    datastore_id = coalesce(try(each.value.storage, null), var.target_storage)
    file_format  = "raw"
    type         = "4m"
  }

  serial_device {
    device = "socket"
  }

  machine       = "q35"
  scsi_hardware = "virtio-scsi-single"

  operating_system {
    type = "l26"
  }

  lifecycle {
    ignore_changes = [
      network_device,
      disk[0].file_id,
    ]
  }
}
