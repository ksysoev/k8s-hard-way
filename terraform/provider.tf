terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}
variable "pvt_key" {}
variable "pub_key" {}


provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "k8shw" {
  name = "k8shwkey"
  public_key = file(var.pub_key)
}

