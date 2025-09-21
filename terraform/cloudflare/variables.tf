variable "domain_name" {
  description = "Base domain name"
  type        = string
  default     = "mulatta.bio"
}

variable "vps_ip" {
  description = "VPS Public IP Address"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

