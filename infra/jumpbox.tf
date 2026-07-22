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
    timeout = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "apt update && apt install -y  apt-transport-https ca-certificates curl gnupg conntrack",
      "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list",
      "apt update && apt install -y kubectl",
    ]
  }

  provisioner "local-exec" {
    command = <<-EOT
    ssh \
      -i ${var.pvt_key} \
      -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/dev/null \
      root@${self.ipv4_address} \
      "mkdir -p /root/.kube" && \
    scp \
      -i ${var.pvt_key} \
      -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/dev/null \
      -o "ProxyCommand=ssh -i ${var.pvt_key} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p root@${self.ipv4_address}" \
      root@${digitalocean_droplet.k8smaster.ipv4_address_private}:/root/.kube/config \
      /tmp/kubeconfig && \
    scp \
      -i ${var.pvt_key} \
      -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/dev/null \
      /tmp/kubeconfig \
      root@${self.ipv4_address}:/root/.kube/config && \
    rm -f /tmp/kubeconfig
  EOT
  }
}
