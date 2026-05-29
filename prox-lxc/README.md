# Proxmox LXC Module (`prox-lxc`)

This module manages the lifecycle of Proxmox LXC containers, including cloud-init style initialization and optional Cloudflare Tunnel ingress rules.

## Usage

```hcl
module "prox_lxc" {
  source   = "github.com/<github-owner>/homelab-terraform-modules//prox-lxc?ref=v0.1.0"
  for_each = local.lxc_containers

  name             = each.value.name
  target_node      = each.value.target_node
  vmid             = each.value.vmid
  memory_mb        = each.value.memory_mb
  cpu_cores        = each.value.cpu_cores
  ip               = each.value.ip
  gateway          = each.value.gateway
  tags             = ["lxc", "managed-by-terraform"]
  unprivileged     = true
  template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  ssh_public_keys  = ["ssh-ed25519 ..."]
}
```

## Features
- Dynamic resource allocation (CPU, RAM, Disk).
- Networking configuration via `ip_config`.
- Optional bind mount configuration.
