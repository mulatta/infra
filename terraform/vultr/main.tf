data "vultr_region" "selected" {
  filter {
    name   = "id"
    values = ["icn"]
  }
}

data "vultr_plan" "selected" {
  filter {
    name   = "id"
    values = [var.plan]
  }
}

data "vultr_os" "selected" {
  filter {
    name   = "name"
    values = [var.os]
  }
}

# Main instance resource
resource "vultr_instance" "eta" {
  hostname = var.hostname
  region   = data.vultr_region.selected.id
  plan     = data.vultr_plan.selected.id
  os_id    = data.vultr_os.selected.id

  enable_ipv6 = false
  backups     = "disabled"

  # Security configuration
  firewall_group_id = vultr_firewall_group.eta.id
}

