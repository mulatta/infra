# ntfy 서브도메인 A 레코드
resource "cloudflare_dns_record" "ntfy" {
  zone_id = var.cloudflare_zone_id
  name    = "ntfy"
  content = var.vps_ip # v5.x에서는 content 사용
  type    = "A"
  ttl     = 300

  # 중요: 프록시 비활성화 (Let's Encrypt용)
  proxied = false

  comment = "ntfy notification server"
}

# www 서브도메인 (선택사항)
resource "cloudflare_dns_record" "www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  content = var.vps_ip
  type    = "A"
  ttl     = 300
  proxied = false
  comment = "www subdomain"
}
