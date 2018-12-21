#!/usr/bin/env bash

# Install required packages
sudo apt-get update
sudo apt-get install software-properties-common -y
sudo apt-get install \
     libc6-dev \
     apt-transport-https \
     ca-certificates \
     curl \
     python-software-properties -y
