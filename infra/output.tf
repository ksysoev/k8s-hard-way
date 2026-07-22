output "bastion_public_ip" {
  description = "The public IP address of the bastion droplet"
  value = digitalocean_droplet.bastion.ipv4_address
}
