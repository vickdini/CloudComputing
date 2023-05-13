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
  - https://github.com/ansible/awx-operator/config/default?ref=2.1.0

# Set the image tags to match the git version from above
images:
  - name: quay.io/ansible/awx-operator
    newTag: 2.1.0

# Specify a custom namespace in which to install AWX
namespace: awx
EOF

minikube kubectl -- apply -k .
rm -rf /tmp/juju-mk*
minikube kubectl -- config set-context --current --namespace=awx

cat <<EOF | sudo tee awx-demo.yaml
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx-demo
spec:
  service_type: nodeport
EOF

cat <<EOF | sudo tee kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  # Find the latest tag here: https://github.com/ansible/awx-operator/releases
  - https://github.com/ansible/awx-operator/config/default?ref=2.1.0
  - awx-demo.yaml

# Set the image tags to match the git version from above
images:
  - name: quay.io/ansible/awx-operator
    newTag: 2.1.0

# Specify a custom namespace in which to install AWX
namespace: awx
EOF

rm -rf /tmp/juju-mk*
minikube kubectl -- apply -k .
