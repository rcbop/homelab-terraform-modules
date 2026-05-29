# Homelab Terraform Modules

Reusable Terraform modules for Proxmox, Talos, K3s, and Cloudflare homelab building blocks.

## Modules

- `prox-cloudflare`: Cloudflare Tunnel ingress and DNS records.
- `prox-k3s`: Proxmox-hosted K3s cluster nodes with cloud-init bootstrap.
- `prox-k8s-talos`: Proxmox-hosted Talos Kubernetes cluster.
- `prox-lxc`: Proxmox LXC container wrapper.
- `prox-vm`: Proxmox VM wrapper.

## Usage

Pin module sources to a release tag:

```hcl
module "example" {
  source = "github.com/<github-owner>/homelab-terraform-modules//prox-vm?ref=v0.1.0"

  # module inputs
}
```

## Security

Do not commit Terraform state, generated Talos configs, kubeconfigs, private inventories, `.tfvars`, encrypted secret files, private keys, API tokens, or real environment-specific hostnames.
