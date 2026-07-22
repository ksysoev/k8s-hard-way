resource "digitalocean_firewall" "bastion_firewall" {
  name = "bastion-firewall"

  droplet_ids = [digitalocean_droplet.bastion.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "master_firewall" {
  name = "master-firewall"

  droplet_ids = [digitalocean_droplet.k8smaster.id]
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["10.0.0.0/24"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "6443"
    source_addresses = ["10.0.0.0/24"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "2379-2380"
    source_addresses = ["10.0.0.0/24"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "10250"
    source_addresses = ["10.0.0.0/24"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "10257"
    source_addresses = ["10.0.0.0/24"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "10259"
    source_addresses = ["10.0.0.0/24"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "worker_firewall" {
  name = "worker-firewall"

  droplet_ids = digitalocean_droplet.k8snode[*].id
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["10.0.0.0/24"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "10250"
    source_addresses = ["10.0.0.0/24"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "10256"
    source_addresses = ["10.0.0.0/24"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "30000-32767"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
