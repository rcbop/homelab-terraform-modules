locals {
  longhorn_worker_disks = {
    for name, node in var.worker_nodes : name => {
      target_node = node.target_node
      host        = coalesce(try(node.longhorn_data_disk.host, null), var.proxmox_node_domain == null ? node.target_node : "${node.target_node}.${var.proxmox_node_domain}")
      ssh_user    = var.longhorn_disk_ssh_user
      vmid        = node.vmid
      slot        = try(node.longhorn_data_disk.slot, 20)
      storage     = coalesce(try(node.longhorn_data_disk.storage, null), var.target_storage)
      size_gb     = try(node.longhorn_data_disk.size_gb, 0)
      serial      = coalesce(try(node.longhorn_data_disk.serial, null), "LH${node.vmid}")
    }
    if try(node.longhorn_data_disk.enabled, false)
  }
}

resource "terraform_data" "longhorn_worker_disk" {
  for_each = local.longhorn_worker_disks

  triggers_replace = [
    each.value.target_node,
    each.value.vmid,
    each.value.slot,
    each.value.storage,
    each.value.size_gb,
    each.value.serial,
  ]

  provisioner "local-exec" {
    command = <<-EOT
      set -eu
      host="${each.value.host}"
      vmid="${each.value.vmid}"
      slot="scsi${each.value.slot}"
      disk="${each.value.storage}:${each.value.size_gb}"
      serial="${each.value.serial}"

      if ssh -o BatchMode=yes -o ConnectTimeout=5 "${each.value.ssh_user}@$host" "sudo qm config $vmid | grep -q '^$slot: .*serial=$serial'"; then
        echo "Longhorn disk $slot already present on $vmid with serial $serial"
        exit 0
      fi

      if ssh -o BatchMode=yes -o ConnectTimeout=5 "${each.value.ssh_user}@$host" "sudo qm config $vmid | grep -q '^$slot:'"; then
        echo "Refusing to overwrite existing $slot on VM $vmid" >&2
        ssh -o BatchMode=yes -o ConnectTimeout=5 "${each.value.ssh_user}@$host" "sudo qm config $vmid | grep '^$slot:'" >&2
        exit 1
      fi

      ssh -o BatchMode=yes -o ConnectTimeout=5 "${each.value.ssh_user}@$host" \
        "sudo qm set $vmid --$slot $disk,backup=0,discard=on,iothread=1,serial=$serial,ssd=1"
    EOT
  }
}
