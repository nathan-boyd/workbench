#!/usr/bin/env bash

GIT_USER_NAME=$(git config user.name)
GIT_USER_EMAIL=$(git config user.email)

PROJECT_DIR=${PWD##*/}
PROJECT_NAME=${PWD#"${PWD%/*/*}/"}
CONTAINER_NAME=${PROJECT_NAME//\//_}

PROJECT_ZSH=${HOME}/.workbench/${PROJECT_NAME}/zsh
if [[ ! -d $PROJECT_ZSH ]]; then
    mkdir -p ${PROJECT_ZSH}
fi

ZSH_HISTORY=${PROJECT_ZSH}/.zsh_history
if [[ ! -e $ZSH_HISTORY ]]; then
    touch $ZSH_HISTORY
fi

TMUX_RESURRECT=${HOME}/.workbench/${PROJECT_NAME}/tmux/resurrect
mkdir -p ${TMUX_RESURRECT}

CONTAINER_HOME="/home/me"
docker run \
    --rm \
    -it \
    -w /${PROJECT_DIR} \
    -v $PWD:/${PROJECT_DIR} \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ~/.ssh:$CONTAINER_HOME/.ssh \
    -v ${TMUX_RESURRECT}:$CONTAINER_HOME/.tmux/resurrect \
    -v ${ZSH_HISTORY}:$CONTAINER_HOME/.zsh_history \
    -v $HOME/.kube:$CONTAINER_HOME/.kube \
    -e HOST_PATH=$PWD \
    -e HOST_USER_ID=$(id -u $USER) \
    -e HOST_GROUP_ID=$(id -g $USER) \
    -e PROJECT_NAME=$PROJECT_NAME \
    -e GIT_USER_NAME="$GIT_USER_NAME" \
    -e GIT_USER_EMAIL="$GIT_USER_EMAIL" \
    --name $CONTAINER_NAME \
    --net host \
    nathan-boyd/workbench:latest
