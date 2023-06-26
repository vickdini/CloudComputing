#!/bin/bash

# Update package list
sudo apt update

# Install Python and other dependencies
sudo apt install -y python3 python3-pip

# Install Ansible
sudo pip3 install ansible

# Create user
useradd ansible
echo password | passwd --stdin ansible
echo "ansible ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ansible
