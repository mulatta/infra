resource "cloudflare_zone" "sjanglab" {
  account = {
    id = "0572d3fa726276fa78f433d5ba90048e"
  }
  name = "sjanglab.org"
  type = "full"
}

resource "cloudflare_dns_record" "ntfy" {
  zone_id = var.cloudflare_zone_id
  name    = "ntfy"
  content = var.vps_ip
  type    = "A"
  ttl     = 300

  proxied = false

  comment = "ntfy notification server"
}

resource "cloudflare_dns_record" "cache" {
  zone_id = var.cloudflare_zone_id
  name    = "cache"
  content = var.vps_ip
  type    = "A"
  ttl     = 300

  proxied = false

  comment = "harmonia binary cache server"
}

resource "cloudflare_dns_record" "www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  content = var.vps_ip
  type    = "A"
  ttl     = 300
  proxied = false
  comment = "www subdomain"
}
