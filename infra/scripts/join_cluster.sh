#!/bin/sh
set -eu

TOKEN="$1"
MASTER_IP="$2"
NODE_IP="$3"

cat >/tmp/kubeadm-join.yaml <<EOF
apiVersion: kubeadm.k8s.io/v1beta4
kind: JoinConfiguration
discovery:
  bootstrapToken:
    token: "${TOKEN}"
    apiServerEndpoint: "${MASTER_IP}:6443"
    unsafeSkipCAVerification: true

nodeRegistration:
  kubeletExtraArgs:
    - name: node-ip
      value: "${NODE_IP}"
EOF

kubeadm join --config /tmp/kubeadm-join.yaml
