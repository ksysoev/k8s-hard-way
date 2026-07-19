#!/bin/sh

cat <<YAML >/tmp/kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta4
kind: InitConfiguration
bootstrapTokens:
- token: "$1"
  ttl: 0s
  usages:
  - signing
  - authentication
---
apiVersion: kubeadm.k8s.io/v1beta4
kind: ClusterConfiguration
networking:
  podSubnet: 10.244.0.0/16
YAML

kubeadm init --config /tmp/kubeadm-config.yaml

mkdir -p "$HOME/.kube"
cp /etc/kubernetes/admin.conf "$HOME/.kube/config"
chown "$(id -u):$(id -g)" "$HOME/.kube/config"

kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
