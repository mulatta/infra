output "instance_info" {
  value = {
    id       = vultr_instance.eta.id
    hostname = vultr_instance.eta.hostname
    region   = vultr_instance.eta.region
    plan     = vultr_instance.eta.plan
    status   = vultr_instance.eta.status
  }
}

output "network_info" {
  value = jsondecode(data.local_file.network_info.content)
}

output "sbee_network_config" {
  value = {
    networking = {
      sbee = {
        currentHost = {
          ipv4    = jsondecode(data.local_file.network_info.content).ipv4
          mac     = jsondecode(data.local_file.network_info.content).mac
          gateway = jsondecode(data.local_file.network_info.content).gateway
          dns     = try(jsondecode(data.local_file.network_info.content).dns, ["8.8.8.8", "1.1.1.1"])
        }
        hosts = {
          "${var.hostname}" = {
            ipv4 = jsondecode(data.local_file.network_info.content).ipv4
          }
        }
      }
    }
  }
}
