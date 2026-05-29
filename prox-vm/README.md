# Proxmox VM Module (`prox-vm`)

This module creates and manages Proxmox Virtual Machines using Cloud-Init for base provisioning.

## Usage

```hcl
module "prox_vm" {
  source   = "github.com/<github-owner>/homelab-terraform-modules//prox-vm?ref=v0.1.0"
  for_each = local.virtual_machines

  name             = each.value.name
  target_node      = each.value.target_node
  vmid             = each.value.vmid
  memory_mb        = each.value.memory_mb
  cpu_cores        = each.value.cpu_cores
  disk_size        = each.value.disk_size
  ip               = each.value.ip
  gateway          = each.value.gateway
  tags             = ["vm", "managed-by-terraform"]
  bios             = "seabios"

  # Optional: USB passthrough
  usb_passthrough = [
    { host = "1-1" }
  ]
}
```

## Features
- Template-based VM cloning.
- Dynamic hardware sizing (CPU, RAM, Disk).
- Networking configuration via `ip_config`.
- Automated Cloud-Init configuration (`user_data_file`).
- USB Passthrough support for specific device IDs.
