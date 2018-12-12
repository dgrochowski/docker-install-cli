#!/usr/bin/env bash

# Uninstall old version
sudo apt-get remove docker docker-engine docker.io -y

# Install Docker CE on Debian Jessie
sudo apt-get update
sudo apt-get install software-properties-common -y
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce -y
