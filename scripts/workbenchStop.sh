#!/usr/bin/env bash

docker container stop workbench-ctop
docker stop $CONTAINER_NAME -t 1
