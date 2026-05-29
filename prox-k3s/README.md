# Proxmox K3s Module (`prox-k3s`)

This module manages a High-Availability K3s cluster on Proxmox VE, utilizing **Cloud-Init (user-data)** for automated bootstrapping.

## Usage
The module uses a Terraform template file (`.tftpl`) to render the cloud-config, ensuring a clean and maintainable bootstrap process.

```hcl
module "k3s" {
  source = "github.com/<github-owner>/homelab-terraform-modules//prox-k3s?ref=v0.1.0"

  cluster_name    = local.cluster_name
  nodes           = local.nodes
  gateway         = local.gateway
  ssh_public_keys = local.ssh_public_keys
  k3s_token       = var.k3s_token
  target_storage  = local.target_storage
  network_bridge  = local.network_bridge

  registry_mirrors = {
    "docker.io" = {
      endpoints = ["https://registry-cache.example.net/v2/docker-hub"]
    }
  }
}
```

## Features
- **Template-Based Bootstrapping**: Cloud-Init configuration is managed in `templates/cloud-config.yaml.tftpl`.
- **Automatic HA**: Handles `--cluster-init` for the first node and automatic joining for subsequent nodes.
- **Enabled Services**: Traefik and ServiceLB are enabled by default for out-of-the-box Ingress and LoadBalancer support.
- **Resource Cleanup**: Reset Machine-ID and enable memory cgroups automatically.
- **Guest Agent**: QEMU Guest Agent is installed and enabled by default.
- **Registry Mirrors**: Optional K3s registry mirror configuration without hardcoded endpoints.
