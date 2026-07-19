#!/bin/sh

export PATH=$PATH:/usr/bin

# Disable SWAP
sudo swapoff -a
sed -i.bak '/\bswap\b/s/^/#/' /etc/fstab

apt update
apt install apt-transport-https ca-certificates curl gnupg conntrack containerd -y

mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

apt update
apt install -y kubelet kubeadm kubectl

echo -e "overlay\nbr_netfilter" | tee /etc/modules-load.d/k8s.conf >/dev/null && modprobe overlay && modprobe br_netfilter
echo -e "net.bridge.bridge-nf-call-iptables = 1\nnet.bridge.bridge-nf-call-ip6tables = 1\nnet.ipv4.ip_forward = 1" | tee /etc/sysctl.d/k8s.conf >/dev/null && sysctl --system
