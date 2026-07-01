---
type: Reference
title: "Modules"
description: "Per-module reference: prox-cloudflare, prox-k3s, prox-k8s-talos, prox-lxc, prox-vm."
tags: [terraform, proxmox, talos, k3s, cloudflare, lxc, vm]
timestamp: 2026-07-01T00:00:00Z
---

# Modules

Reusable Terraform modules for Proxmox, Talos, K3s, and Cloudflare homelab building blocks.

## Module Inventory

| Module | Purpose |
|--------|---------|
| `prox-cloudflare` | Cloudflare Tunnel ingress and DNS records |
| `prox-k3s` | Proxmox-hosted K3s cluster nodes with cloud-init bootstrap |
| `prox-k8s-talos` | Proxmox-hosted Talos Kubernetes cluster |
| `prox-lxc` | Proxmox LXC container wrapper |
| `prox-vm` | Proxmox VM wrapper |

## Usage

Pin module sources to a release tag:

```hcl
module "example" {
  source = "github.com/<github-owner>/homelab-terraform-modules//prox-vm?ref=v0.1.0"

  # module inputs
}
```