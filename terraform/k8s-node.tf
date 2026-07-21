
resource "random_string" "token_id" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "token_secret" {
  length  = 16
  special = false
  upper   = false
}

locals {
  custom_token = "${random_string.token_id.result}.${random_string.token_secret.result}"
}

resource "digitalocean_droplet" "k8smaster" {
  image = "ubuntu-26-04-x64"
  name = "k8smaster"
  region = "sgp1"
  size = "s-2vcpu-2gb"
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

  provisioner "file" {
    source = "scripts/bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  
  provisioner "file" {
    source = "scripts/init_cluster.sh"
    destination = "/tmp/init_cluster.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh /tmp/init_cluster.sh",
      "/tmp/bootstrap.sh",
      "/tmp/init_cluster.sh ${local.custom_token} ${digitalocean_droplet.k8smaster.ipv4_address_private}"
    ]
  }
}

resource "digitalocean_droplet" "k8snode" {
  count = 2
  image = "ubuntu-26-04-x64"
  name = "k8snode"
  region = "sgp1"
  size = "s-2vcpu-2gb"
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

  provisioner "file" {
    source = "scripts/bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh /tmp/init_cluster.sh",
      "/tmp/bootstrap.sh",
      "kubeadm join ${digitalocean_droplet.k8smaster.ipv4_address_private}:6443 --token \"${local.custom_token}\" --discovery-token-unsafe-skip-ca-verification",
    ]
  }
}
