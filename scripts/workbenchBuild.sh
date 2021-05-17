#!/usr/bin/env bash

# always fail script if a cmd fails
set -eo pipefail

# required commands
command -v docker >/dev/null 2>&1 || { echo "docker is required but not installed, aborting..." >&2; exit 1; }

USER_ID="$(id -u ${USER})"
GROUP_ID="1001"

export DOCKER_BUILDKIT=0 \
&& docker build . \
    --build-arg USER_NAME="$USER" \
    --build-arg USER_ID="${USER_ID}" \
    --build-arg GROUP_ID="${GROUP_ID}" \
    -f Dockerfile \
    -t nathan-boyd/workbench:latest

# --no-cache \
