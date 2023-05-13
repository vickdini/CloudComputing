#!/bin/bash

sudo apt update

# Install Docker
sudo apt install -y docker.io

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb

minikube config set driver docker
minikube delete
minikube start --force

cat <<EOF | sudo tee kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  # Find the latest tag here: https://github.com/ansible/awx-operator/releases
  #- https://github.com/ansible/awx-operator/tree/devel/config/default?ref=latest
  - https://github.com/ansible/awx-operator/config/default?ref=latest

# Set the image tags to match the git version from above
images:
  - name: quay.io/ansible/awx-operator
    newTag: latest

# Specify a custom namespace in which to install AWX
namespace: awx
EOF

minikube kubectl -- apply -k .
