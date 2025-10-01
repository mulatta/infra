output "instance_info" {
  value = {
    id       = vultr_instance.eta.id
    hostname = vultr_instance.eta.hostname
    region   = vultr_instance.eta.region
    plan     = vultr_instance.eta.plan
    status   = vultr_instance.eta.status
    ipv4     = vultr_instance.eta.main_ip
    gateway  = vultr_instance.eta.gateway_v4
  }
}
