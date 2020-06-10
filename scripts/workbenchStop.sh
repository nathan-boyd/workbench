#!/usr/bin/env bash

docker container stop "workbench-${PROJECT_DIR}-ctop" > /dev/null 2>&1 &
docker stop $CONTAINER_NAME -t 1
