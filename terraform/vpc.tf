resource "digitalocean_ssh_key" "k8shw" {
  name = "k8shwkey"
  public_key = file(var.pub_key)
}

resource "digitalocean_vpc" "k8s_network" {
  name   = "k8s-cluster-network"
  region = "sgp1"
}
