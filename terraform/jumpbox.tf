resource "digitalocean_droplet" "bastion" {
  image = "ubuntu-26-04-x64"
  name = "bastion"
  region = "sgp1"
  size = "s-1vcpu-512mb-10gb"
  ssh_keys = [
    resource.digitalocean_ssh_key.k8shw.id
  ]
  vpc_uuid = digitalocean_vpc.k8s_network.id 

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }
}
