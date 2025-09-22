output "cloudflare_nameservers" {
  value = cloudflare_zone.sjanglab.name_servers
}

output "zone_id" {
  value = cloudflare_zone.sjanglab.id
}

output "ntfy_url" {
  description = "ntfy service URL"
  value       = "https://ntfy.${var.domain_name}"
}

output "ntfy_record" {
  description = "Created DNS record"
  value = {
    name    = cloudflare_dns_record.ntfy.name
    content = cloudflare_dns_record.ntfy.content
  }
}

output "www_record" {
  description = "Created www DNS record"
  value = {
    name    = cloudflare_dns_record.www.name
    content = cloudflare_dns_record.www.content
  }
}
