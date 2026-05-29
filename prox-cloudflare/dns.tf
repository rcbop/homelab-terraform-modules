resource "cloudflare_dns_record" "records" {
  for_each = { for r in var.dns_records : r.name => r }

  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  content = each.value.value
  ttl     = 1
  proxied = each.value.proxied
}

moved {
  from = cloudflare_record.records
  to   = cloudflare_dns_record.records
}
