#!/bin/bash

sudo apt update

sudo apt install -y openjdk-19-jre-headless ca-certificates curl gnupg lsb-release

mkdir /home/jenkins
sudo adduser --group --home /home/jenkins --shell /bin/bash jenkins
