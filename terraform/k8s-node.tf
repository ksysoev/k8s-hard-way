resource "digitalocean_droplet" "k8sn1" {
  image = "ubuntu-26-04-x64"
  name = "k8sn1"
  region = "sgp1"
  size = "s-1vcpu-1gb"
  ssh_keys = [
    resource.digitalocean_ssh_key.k8shw.id
  ]
  
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }
  
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "apt update",
      "apt install docker.io -y",
      "systemctl enable docker",
      "mkdir -p /etc/docker",
      "echo '{\"exec-opts\": [\"native.cgroupdriver=systemd\"]}' | sudo tee /etc/docker/daemon.json",
      "systemctl start docker",
    ]
  }
}
