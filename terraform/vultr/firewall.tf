resource "vultr_firewall_group" "eta" {
  description = "Firewall rules for eta"
}

resource "vultr_firewall_rule" "ssh" {
  firewall_group_id = vultr_firewall_group.eta.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = 22
  notes             = "SSH access on port 22"
}

resource "vultr_firewall_rule" "ssh-alt" {
  firewall_group_id = vultr_firewall_group.eta.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = 10022
  notes             = "SSH access on port 10022"
}

output "firewall_info" {
  description = "Firewall configuration details"
  value = {
    firewall_group_id   = vultr_firewall_group.eta.id
    description         = vultr_firewall_group.eta.description
    applied_to_instance = vultr_instance.eta.id
  }
}
