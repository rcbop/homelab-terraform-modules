variable "account_id" {
  type        = string
  description = "Cloudflare Account ID"
}

variable "zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
}

variable "tunnel_id" {
  type        = string
  description = "Cloudflare Tunnel ID"
  default     = null
}

variable "ingress_rules" {
  type = list(object({
    hostname = string
    service  = string
  }))
  description = "List of ingress rules for the tunnel"
  default     = []
}

variable "dns_records" {
  type = list(object({
    name    = string
    type    = string
    value   = string
    proxied = optional(bool, true)
  }))
  description = "List of DNS records to manage"
  default     = []
}

variable "warp_routing" {
  type        = bool
  description = "Enable WARP routing for the tunnel"
  default     = false
}
