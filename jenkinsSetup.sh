#!/bin/bash

# Install Java
apt update
apt install -y openjdk-11-jre

# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt update
apt install -y jenkins

# Get password for the Jenkins website
cat /var/lib/jenkins/secrets/initialAdminPassword

# Get the server's IP address
 ip a | grep inet
