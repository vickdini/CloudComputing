#!/bin/bash

# Update package list
sudo apt update

# Install Python and other dependencies
sudo apt install -y python3 python3-pip

# Install Ansible
sudo pip3 install ansible

# Create user
useradd ansible
mkdir /home/ansible
chown ansible /home/ansible
echo "ansible:password" | chpasswd
echo "ansible ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ansible
ssh-keygen
su - ansible
ssh-keygen

# ssh-copy-id -i .ssh/id_rsa user@host
