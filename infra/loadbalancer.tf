resource "digitalocean_loadbalancer" "public" {
  name   = "loadbalancer-1"
  region = "sgp1"

  forwarding_rule {
    entry_port     = 30080
    entry_protocol = "http"

    target_port     = 30080
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  vpc_uuid = digitalocean_vpc.k8s_network.id

  droplet_ids = digitalocean_droplet.k8snode[*].id
}
