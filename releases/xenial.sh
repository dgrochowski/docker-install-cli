#!/usr/bin/env bash

# Install required packages
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y
