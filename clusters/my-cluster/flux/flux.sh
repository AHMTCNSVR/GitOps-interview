#!/bin/bash
# install flux
kubectl config current-context
kubectl get nodes
kubectl create ns flux
curl -s https://fluxcd.io/install.sh | sudo bash
. <(flux completion bash)

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=GitOps-interview \
  --branch=main \
  --path=./clusters/my-cluster \
  --personal