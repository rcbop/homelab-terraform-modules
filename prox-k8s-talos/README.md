# Proxmox Talos K8s Module (`prox-k8s-talos`)

This module manages the provisioning of a High-Availability Talos Kubernetes cluster on Proxmox VE.

## Usage

```hcl
module "prox_k8s_talos" {
  source = "github.com/<github-owner>/homelab-terraform-modules//prox-k8s-talos?ref=v0.1.0"

  cluster_name     = local.cluster_name
  cluster_endpoint = local.cluster_endpoint
  talos_version    = local.talos_version
  network_bridge   = local.network_bridge
  target_storage   = local.target_storage
  network_gateway  = local.network_gateway
  nameservers      = local.nameservers

  control_plane_nodes = local.control_plane_nodes
  worker_nodes        = local.worker_nodes
}
```

## Features
- Automated Talos machine configuration generation.
- Provisioning for control planes and workers.
- Output for `talosconfig` and `kubeconfig`.
- Integration with Proxmox CSI storage.
- High-availability support with multi-node control planes.
- Optional control-plane VIP and Longhorn disk attachment helper.
