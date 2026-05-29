resource "proxmox_virtual_environment_vm" "talos_worker" {
  for_each = var.worker_nodes

  name        = each.value.name
  description = "Talos Linux Worker - Managed by Terraform"
  node_name   = each.value.target_node
  tags        = ["homelab", "k8s", "worker"]
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
    datastore_id = var.target_storage
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
    datastore_id = var.target_storage
    file_format  = "raw"
    type         = "4m"
  }

  serial_device {}

  machine       = "q35"
  scsi_hardware = "virtio-scsi-single"

  dynamic "hostpci" {
    for_each = each.value.pci_devices
    content {
      device  = hostpci.value.device
      mapping = try(hostpci.value.mapping, null)
      pcie    = hostpci.value.pcie
      mdev    = try(hostpci.value.mdev, null)
      xvga    = false
    }
  }

  operating_system {
    type = "l26"
  }

  lifecycle {
    ignore_changes = [
      network_device,
      disk,
      disk[0].file_id,
    ]
  }
}
