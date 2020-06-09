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

# Eventually may just mount the .workbench directory and symlink within the container

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

# the directory in which to store vim undo files
PROJECT_UNDO=${HOME}/.workbench/${PROJECT_NAME}/vim/undodir
if [[ ! -d $PROJECT_UNDO ]]; then
    mkdir -p ${PROJECT_UNDO}
fi

# stores vim sessions
PROJECT_SESSION=${HOME}/.workbench/${PROJECT_NAME}/vim/session
if [[ ! -d $PROJECT_SESSION ]]; then
    mkdir -p ${PROJECT_SESSION}
fi

PROJECT_AUTOJUMP=${HOME}/.workbench/${PROJECT_NAME}/autojump
if [[ ! -d $PROJECT_AUTOJUMP ]]; then
    mkdir -p ${PROJECT_AUTOJUMP}
    touch ${PROJECT_AUTOJUMP}/autojump.txt
fi

docker run \
    --rm \
    -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/.ssh:$CONTAINER_HOME/.ssh \
    -v $PWD:${CONTAINER_HOME}/${PROJECT_DIR} \
    -v ${ZSH_HISTORY}:$CONTAINER_HOME/.zsh_history \
    -v $HOME/.kube/config:$CONTAINER_HOME/.kube/config \
    -v ${PROJECT_TMUXINATOR}:$CONTAINER_HOME/.config/tmuxinator \
    -v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK \
    -v $PROJECT_AUTOJUMP:$CONTAINER_HOME/.local/share/autojump/ \
    -v ${PROJECT_UNDO}:$CONTAINER_HOME/.config/.vim/undodir \
    -v $PROJECT_SESSION:$CONTAINER_HOME/.config/nvim/sessions/ \
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
    -w ${CONTAINER_HOME}/${PROJECT_DIR} \
    --name $CONTAINER_NAME \
    --net host \
    nathan-boyd/workbench:latest
