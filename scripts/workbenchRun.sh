#!/usr/bin/env bash

if [ ! -n $(docker ps -a --format '{{ .Names }}' | grep -oE workbench) ]; then
	echo "workbench already exists!" >&2;
	exit 1;
fi

GIT_USER_NAME=$(git config user.name)
GIT_USER_EMAIL=$(git config user.email)

PROJECT_DIR=${PWD##*/}
PROJECT_NAME=${PWD#"${PWD%/*/*}/"}
CONTAINER_NAME=${PROJECT_NAME//\//_}
CONTAINER_HOME="/home/me"

PROJECT_ZSH=${HOME}/.workbench/${PROJECT_NAME}/zsh
if [[ ! -d $PROJECT_ZSH ]]; then
    mkdir -p ${PROJECT_ZSH}
fi

ZSH_HISTORY=${PROJECT_ZSH}/.zsh_history
if [[ ! -e $ZSH_HISTORY ]]; then
    touch $ZSH_HISTORY
fi


PROJECT_TMUXINATOR=${HOME}/.workbench/${PROJECT_NAME}/tmuxinator
if [[ ! -d $PROJECT_ZSH ]]; then
    mkdir -p ${PROJECT_TMUXINATOR}
fi

docker run \
    --rm \
    -it \
    -w ${CONTAINER_HOME}/${PROJECT_DIR} \
    -v $PWD:${CONTAINER_HOME}/${PROJECT_DIR} \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ~/.ssh:$CONTAINER_HOME/.ssh \
    -v ${PROJECT_TMUXINATOR}:$CONTAINER_HOME/.config/tmuxinator \
    -v ${ZSH_HISTORY}:$CONTAINER_HOME/.zsh_history \
    -v $HOME/.kube/config:$CONTAINER_HOME/.kube/config \
    -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) \
    -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    -e ITERM_PROFILE=$ITERM_PROFILE \
    -e HOST_PATH=$PWD \
    -e HOST_USER_ID=$(id -u $USER) \
    -e HOST_GROUP_ID=$(id -g $USER) \
    -e PROJECT_NAME=$PROJECT_NAME \
    -e PROJECT_DIR=$PROJECT_DIR \
    -e GIT_USER_NAME="$GIT_USER_NAME" \
    -e GIT_USER_EMAIL="$GIT_USER_EMAIL" \
    -e CONTAINER_NAME="$CONTAINER_NAME" \
    --name $CONTAINER_NAME \
    --net host \
    nathan-boyd/workbench:latest
