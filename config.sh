#!/usr/bin/env bash

##### CONFIG #####
# Leave empty to choose automatically or pick one:
# jessie/wheezy/precise/trusty/xenial/bionic
OPERATING_SYSTEM=

# OAuth client and secret id's required if Github API Rate limit has been exceed
# Read more, @see https://developer.github.com/v3/rate_limit/
GITHUB_CLIENT_ID=
GITHUB_SECRET_ID=

# Force docker-compose version - if latest then version will be fetched from API automatically
DOCKER_COMPOSE_VERSION=latest
##### EOF CONFIG #####
