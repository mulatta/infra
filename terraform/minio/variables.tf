variable "tunnel_jumphost_ip" {
  description = "SSH jumphost IP address"
  type        = string
}

variable "tunnel_jumphost_user" {
  description = "SSH jumphost username"
  type        = string
}

variable "tunnel_jumphost_port" {
  description = "SSH jumphost port"
  type        = number
  default     = 22
}

variable "tunnel_target_ip" {
  description = "MinIO server IP address"
  type        = string
}

variable "tunnel_target_port" {
  description = "MinIO server port"
  type        = number
  default     = 9000
}

variable "tunnel_local_port" {
  description = "Local tunnel port"
  type        = number
  default     = 9000
}

variable "minio_ssl_enabled" {
  description = "Enable SSL for MinIO connection"
  type        = bool
  default     = false
}

variable "minio_insecure_ssl" {
  description = "Allow insecure SSL connections"
  type        = bool
  default     = true
}
