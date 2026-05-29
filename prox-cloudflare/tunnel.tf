resource "cloudflare_zero_trust_tunnel_cloudflared_config" "this" {
  count      = var.tunnel_id != null ? 1 : 0
  account_id = var.account_id
  tunnel_id  = var.tunnel_id

  config = {
    ingress = concat(
      [
        for rule in var.ingress_rules : {
          hostname = rule.hostname
          service  = rule.service
        }
      ],
      [
        {
          service = "http_status:404"
        }
      ]
    )

    warp_routing = {
      enabled = var.warp_routing
    }
  }
}
