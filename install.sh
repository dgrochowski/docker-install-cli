#!/usr/bin/env bash

source ./config.sh

if [ -z $OPERATING_SYSTEM ] ; then
    OPERATING_SYSTEM=$(lsb_release -cs)
fi

if [ ! -f "./releases/$OPERATING_SYSTEM.sh" ] ; then
    printf "Your operating system ($OPERATING_SYSTEM) is not supported. You can force OS in config.sh file\n"
    exit
fi

source "./releases/$OPERATING_SYSTEM.sh"

OS_RELEASE=$(lsb_release -si)
OS_RELEASE=${OS_RELEASE,,}
OS_RELEASE=${OS_RELEASE//\"}

# Fetch latest docker-compose version if not forced in config
if [ -z $DOCKER_COMPOSE_VERSION ] || [ $DOCKER_COMPOSE_VERSION == 'latest' ] ; then
    OAUTH_STRING=
    if [ ! -z $GITHUB_CLIENT_ID ] && [ ! -z $GITHUB_SECRET_ID ] ; then
        OAUTH_STRING="?client_id=$GITHUB_CLIENT_ID&client_secret=$GITHUB_SECRET_ID"
    fi
    LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://api.github.com/repos/docker/compose/releases/latest$OAUTH_STRING)
    DOCKER_COMPOSE_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name": "\([^"]*\)".*/\1/')
fi

if [ ${DOCKER_COMPOSE_VERSION:0:1} == "{" ] ; then
    echo $DOCKER_COMPOSE_VERSION
    exit
fi

DOCKER_COMPOSE_DOWNLOAD_URL="https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64"
if [[ 'Not Found' == $(curl --silent $DOCKER_COMPOSE_DOWNLOAD_URL) ]] ; then
    echo "Docker-compose version '$DOCKER_COMPOSE_VERSION' cannot be found!"
    exit
fi

# Install docker-compose
sudo curl -Ls $DOCKER_COMPOSE_DOWNLOAD_URL -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Uninstall old docker version
sudo apt-get remove docker docker-engine docker.io -y
sudo apt-get purge docker-ce -y

# Install Docker CE
curl -fsSL "https://download.docker.com/linux/$OS_RELEASE/gpg" | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$OS_RELEASE \
   $OPERATING_SYSTEM \
   stable"
sudo apt-get update
sudo apt-get install docker-ce -y

# Add privileges
sudo groupadd docker
sudo usermod -aG docker $USER

# Protect against incorrect state
sudo rm -rf /var/lib/docker
sudo systemctl restart docker

# Relog to get an access to the 'docker' group
printf "\n################################################\n"
printf "Docker and docker-compose installation complete."
printf "\n################################################\n"

if [[ ! $(groups | grep docker) ]] ; then
    printf "\nPlease sign out and sign in to reload groups.\n"
    exit
fi

# Ask about run test.sh
printf "\n"
read -p "Would you like to test docker now? [y/n]: " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    source ./test.sh
fi
