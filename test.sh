#!/usr/bin/env bash

dc_info () {
    printf "\n##################################################\n"
    printf "### List all containers$1:\n"
    docker ps -a
    printf "\n"
}

docker-compose -f compose-test.yml build
dc_info ' after docker-compose build'

docker-compose -f compose-test.yml up -d
dc_info ' after docker-compose up'

docker-compose -f compose-test.yml down
dc_info ' after docker-compose down'
