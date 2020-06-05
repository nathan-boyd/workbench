#!/usr/bin/env bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPODIR="$(dirname "$SCRIPTDIR")"

PROJECT_DIR=${PWD##*/}
PROJECT_NAME=${PWD#"${PWD%/*/*}/"}
CONTAINER_NAME=${PROJECT_NAME//\//_}

TMUX_RESURRECT=${HOME}/.ide/${PROJECT_NAME}/tmux/resurrect
mkdir -p ${TMUX_RESURRECT}

ZSH=${HOME}/.workbench/${PROJECT_NAME}/zsh/
mkdir -p ${ZSH}
touch ${ZSH}/zsh_history

GIT_USER_NAME=$(git config user.name)
GIT_USER_EMAIL=$(git config user.email)

# todo dynamic .kube and .helm

docker run \
    --rm \
    -it \
    -w /${PROJECT_DIR} \
    -v $PWD:/${PROJECT_DIR} \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ~/.ssh:/home/me/.ssh \
    -v ${TMUX_RESURRECT}:/home/me/.tmux/resurrect \
    -v ${ZSH_HISTORY}:/home/me/.zsh_history \
    -e HOST_PATH=$PWD \
    -e HOST_USER_ID=$(id -u $USER) \
    -e HOST_GROUP_ID=$(id -g $USER) \
    -e PROJECT_NAME=$PROJECT_NAME \
    -e GIT_USER_NAME="$GIT_USER_NAME" \
    -e GIT_USER_EMAIL="$GIT_USER_EMAIL" \
    -e KUBE_HOME="$HOME/.kube" \
    -e HELM_HOME="$HOME/.helm" \
    --name $CONTAINER_NAME \
    --net host \
    nathan-boyd/workbench:latest
