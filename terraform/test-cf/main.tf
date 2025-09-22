terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    sops = {
      source = "carlpett/sops"
    }

  }
}

provider "cloudflare" {
  api_token = data.sops_file.secrets.data["CLOUDFLARE_API_TOKEN"]
}

data "cloudflare_accounts" "main" {}

resource "cloudflare_zone" "sjanglab" {
  account_id = data.cloudflare_accounts.main.accounts[0].id
  zone       = "sjanglab.org"
  plan       = "free"
  type       = "full"
}

# DNS 레코드들
resource "cloudflare_record" "main_a_1" {
  zone_id = cloudflare_zone.sjanglab.id
  name    = "@"
  value   = "185.230.63.171"
  type    = "A"
  ttl     = 3600
  proxied = true
}

output "account_id" {
  value = data.cloudflare_accounts.main.accounts[0].id
}

output "zone_id" {
  value = cloudflare_zone.sjanglab.id
}

output "nameservers" {
  value = cloudflare_zone.sjanglab.name_servers
}
