locals {
  first_node_key = keys(var.nodes)[0]
  join_node_keys = slice(keys(var.nodes), 1, length(keys(var.nodes)))
}

# This was missing or undeclared according to your error
resource "proxmox_virtual_environment_file" "cloud_config" {
  for_each     = var.nodes
  content_type = "snippets"
  datastore_id = "local"
  node_name    = each.value.target_node

  source_raw {
    data = templatefile("${path.module}/templates/cloud-config.yaml.tftpl", {
      hostname         = each.value.name
      ip               = each.value.ip
      ssh_public_keys  = var.ssh_public_keys
      k3s_token        = var.k3s_token
      is_first_node    = each.key == local.first_node_key
      first_node_ip    = var.nodes[local.first_node_key].ip
      registry_mirrors = var.registry_mirrors
      registries_yaml  = yamlencode({ mirrors = var.registry_mirrors })
    })
    file_name = "k3s-cloud-config-${each.key}.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "nodes" {
  for_each  = var.nodes
  name      = each.value.name
  node_name = each.value.target_node
  vm_id     = each.value.vmid
  tags      = ["k3s", var.cluster_name, "managed-by-terraform"]
  bios      = "seabios"

  vga {
    type = "std"
  }

  serial_device {
    device = "socket"
  }

  clone {
    vm_id = each.value.template_id
    full  = false
  }

  cpu {
    cores = each.value.cpu_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory_mb
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = var.network_bridge
  }

  disk {
    datastore_id = var.target_storage
    interface    = "scsi0"
    size         = each.value.disk_size
    file_format  = "raw"
  }

  operating_system {
    type = "l26"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = var.gateway
      }
    }
    user_account {
      keys     = var.ssh_public_keys
      username = "root"
    }
    user_data_file_id = proxmox_virtual_environment_file.cloud_config[each.key].id
  }

  lifecycle {
    ignore_changes = [
      network_device,
      initialization,
      vm_id,
      operating_system,
      bios,
      disk,
    ]
  }
}
