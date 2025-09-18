terraform {
  required_providers {
    minio = {
      source = "aminueza/minio"
    }
    sops = {
      source = "carlpett/sops"
    }
    external = {
      source = "hashicorp/external"
    }

  }
}


module "minio_tunnel" {
  source  = "flaupretre/tunnel/ssh"
  version = "2.3.2"

  gateway_host = var.tunnel_jumphost_ip
  gateway_user = var.tunnel_jumphost_user
  gateway_port = var.tunnel_jumphost_port

  target_host = var.tunnel_target_ip
  target_port = var.tunnel_target_port
  local_port  = var.tunnel_local_port
}


provider "minio" {
  alias = "tunnel"

  minio_server = "${module.minio_tunnel.host}:${module.minio_tunnel.port}"

  minio_user     = data.sops_file.secrets.data["MINIO_ROOT_USER"]
  minio_password = data.sops_file.secrets.data["MINIO_ROOT_PASSWORD"]

  minio_ssl      = var.minio_ssl_enabled
  minio_insecure = var.minio_insecure_ssl
}
