#!/bin/bash

# Update package lists
sudo apt update

# Install dependencies
sudo apt install -y curl gcc git libffi-dev libssl-dev make python3-pip python3-dev redis-server apache2 libapache2-mod-wsgi-py3

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo pip3 install docker-compose

# Clone AWX repository
git clone --depth 50 https://github.com/ansible/awx.git

# Change directory to installer
cd awx/installer

# Create inventory file
cat <<EOF > inventory
[all]
localhost ansible_connection=local

[docker]

[all:vars]
dockerhub_base=ansible
awx_task_hostname=awx
awx_web_hostname=awxweb
host_port=80
EOF

# Install AWX
ansible-playbook -i inventory install.yml

# Configure Apache HTTP Server
sudo cp -r ../awx/public/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Enable WSGI module
sudo a2enmod wsgi

# Configure virtual host
sudo cp ../awx/installer/nginx.conf /etc/apache2/sites-available/awx.conf
sudo ln -s /etc/apache2/sites-available/awx.conf /etc/apache2/sites-enabled/
sudo systemctl restart apache2

