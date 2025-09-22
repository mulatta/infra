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

variable "ssh_public_key_path" {
  description = "Path to SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

