#!/bin/bash

# Update package lists
sudo apt update

apt install -y docker.io docker-compose ansible nodejs npm unzip python3-pip git pwgen
pip3 install awxkit setuptools-scm

wget https://github.com/ansible/awx/archive/refs/tags/22.2.0.zip
unzip 22.2.0.zip
cd awx-22.2.0

git init

make docker-compose-build
