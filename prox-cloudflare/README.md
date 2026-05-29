# Cloudflare Tunnel Module (`prox-cloudflare`)

This module manages Cloudflare Tunnel ingress configuration and matching proxied DNS records.

## Usage

```hcl
module "cloudflare_tunnel" {
  source = "github.com/<github-owner>/homelab-terraform-modules//prox-cloudflare?ref=v0.1.0"

  account_id = var.cloudflare_account_id
  zone_id    = var.cloudflare_zone_id
  tunnel_id  = var.cloudflare_tunnel_id

  ingress_rules = [
    {
      hostname = "app.example.com"
      service  = "http://app.namespace.svc.cluster.local:80"
    }
  ]

  dns_records = [
    {
      name  = "app"
      type  = "CNAME"
      value = "tunnel-id.cfargotunnel.com"
    }
  ]
}
```

## Features

- Creates proxied CNAME DNS records for tunnel routes.
- Builds a Cloudflare Tunnel ingress config with a final `http_status:404` fallback.
