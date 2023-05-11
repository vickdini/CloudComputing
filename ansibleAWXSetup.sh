#!/bin/bash

# Update package lists
sudo apt update

# Run the VM with the host processor

sudo apt install -y docker.io docker-compose ansible nodejs npm unzip python3-pip git pwgen
pip3 install awxkit setuptools-scm

wget https://github.com/ansible/awx/archive/refs/tags/22.2.0.zip
unzip 22.2.0.zip
cd awx-22.2.0

##Values are written out to tools/docker-compose/_sources/secrets/

git init

make docker-compose-build

make docker-compose

docker exec tools_awx_1 make clean-ui ui-devel

echo "The UI can be reached in your browser at https://localhost:8043/#/home"
