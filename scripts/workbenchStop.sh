#!/usr/bin/env bash

sudo docker container stop "workbench-${PROJECT_DIR}-ctop" > /dev/null 2>&1 &
sudo docker stop $CONTAINER_NAME -t 1
