#!/usr/bin/env bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPODIR="$(dirname "$SCRIPTDIR")"
cd "$REPODIR"

# always fail script if a cmd fails
set -eo pipefail

# required commands
command -v docker >/dev/null 2>&1 || { echo "docker is required but not installed, aborting..." >&2; exit 1; }

docker build . \
    -f Dockerfile \
    -t nathan-boyd/workbench:latest
