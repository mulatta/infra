variable "plan" {
  description = "Vultr plan ID for the instance"
  type        = string
  default     = "vhp-2c-4gb-amd"
}

variable "hostname" {
  description = "NixOS hostname"
  type        = string
  default     = "nixos-vultr"
}

variable "os" {
  description = "Operating system name"
  type        = string
  default     = "Ubuntu 22.04 LTS x64"
}

