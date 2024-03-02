#!/usr/bin/env bash
# nginx_install.sh
sleep 10
sudo apt update -y
sudo apt-get install nginx -y
sudo systemctl start nginx

#!/bin/bash

## 1. Package update
sudo apt list --upgradable
sudo apt update -y


## 2. Installation of dependencies for Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

## 3. Adding the official Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

## 4. Adding the Docker repository to APT sources
echo "" | sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

## 5. Updating the package list
sudo apt update -y

## 6. Docker installation
sudo apt install -y docker-ce

## 7. Checking the status of Docker
#sudo systemctl status docker

## 8. Adding the user to the Docker group
sudo usermod -aG docker $USER
sudo systemctl start docker
sudo systemctl enable docker

## 9. Git installation
sudo apt install -y git

echo "Docker et Git ont été installés avec succès."
