output "instance_info" {
  value = {
    id       = vultr_instance.eta.id
    hostname = vultr_instance.eta.hostname
    region   = vultr_instance.eta.region
    plan     = vultr_instance.eta.plan
    status   = vultr_instance.eta.status
  }
}
