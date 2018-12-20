#!/usr/bin/env bash

# Install required packages
sudo apt-get update
sudo apt-get install software-properties-common -y
sudo apt-get install \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual -y
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y
