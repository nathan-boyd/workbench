#!/usr/bin/env bash

# always fail script if a cmd fails
set -eo pipefail

# required commands
command -v docker >/dev/null 2>&1 || { echo "docker is required but not installed, aborting..." >&2; exit 1; }

docker build . \
    -f Dockerfile \
    -t nathan-boyd/workbench:latest
