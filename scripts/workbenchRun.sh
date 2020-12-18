#!/usr/bin/env bash

GIT_USER_NAME=$(git config user.name)
GIT_USER_EMAIL=$(git config user.email)

PROJECT_DIR=${PWD##*/}
PROJECT_NAME=${PWD#"${PWD%/*/*}/"}
CONTAINER_NAME=${PROJECT_NAME//\//_}
CONTAINER_HOME="/home/me"

if [ ! -n $(docker ps -a --format '{{ .Names }}' | grep -oE ${CONTAINER_NAME}) ]; then
	echo "workbench already exists!" >&2;
	exit 1;
fi

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

GO_PKG=${HOME}/.workbench/golang/pkg
if [[ ! -d $GO_PKG ]]; then
    mkdir -p $GO_PKG
fi

GO_BIN=${HOME}/.workbench/golang/bin
if [[ ! -d $GO_BIN ]]; then
    mkdir -p $GO_BIN
fi

GO_BUILD_CACHE=${HOME}/.workbench/golang/build-cache
if [[ ! -d $GO_BUILD_CACHE ]]; then
    mkdir -p $GO_BUILD_CACHE
fi

LAZY_DOCKER=${HOME}/.workbench/lazydocker
if [[ ! -d $LAZY_DOCKER ]]; then
    mkdir -p $LAZY_DOCKER
    echo 'reporting: "off"' > $LAZY_DOCKER/config.yml
fi

GATEWAY=$(ip route | grep default | grep -Eio 'en{1}\d' | head -1)
if [ -z "$GATEWAY" ]
then
    echo "could not find default gateway"
else
    echo "found default gateway at $GATEWAY"
fi

IP=$(ifconfig "$GATEWAY" | grep inet | awk '$1=="inet" {print $2}')
if [ -z "$IP" ]
then
    echo "could not find default network IP, host clipboard integration may not function properly"
fi

if pgrep -x "xhost" >/dev/null
then
    echo "xhost is already running at: $IP"
else
    xhost + $IP > /dev/null &
    echo "started xhost on host at: $IP"
fi

echo "starting docker container"

docker run \
    --rm \
    -it \
    -v $HOME/Desktop/:$CONTAINER_HOME/Desktop \
    -v $HOME/.docker/:$CONTAINER_HOME/.docker/ \
    -v $HOME/.kube/config:$CONTAINER_HOME/.kube/config \
    -v $HOME/.ssh:$CONTAINER_HOME/.ssh \
    -v $HOME/.workbench:$CONTAINER_HOME/.workbench \
    -v $HOME/.local/share/virtualenvs:$CONTAINER_HOME/.local/share/virtualenvs \
    -v $LAZY_DOCKER:$CONTAINER_HOME/.config/jesseduffield/lazydocker \
    -v $PROJECT_AUTOJUMP:$CONTAINER_HOME/.local/share/autojump/ \
    -v $PROJECT_SESSION:$CONTAINER_HOME/.config/nvim/sessions/ \
    -v $PWD:${CONTAINER_HOME}/${PROJECT_DIR} \
    -v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK \
    -v ${PROJECT_TMUXINATOR}:$CONTAINER_HOME/.config/tmuxinator \
    -v ${PROJECT_UNDO}:$CONTAINER_HOME/.config/.vim/undodir \
    -v ${ZSH_HISTORY}:$CONTAINER_HOME/.zsh_history \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e ARTIFACTORY_APIKEY="$ARTIFACTORY_APIKEY" \
    -e ARTIFACTORY_USER="$ARTIFACTORY_USER" \
    -e ARTIFACTORY_AUTH="$ARTIFACTORY_AUTH" \
    -e ARTIFACTORY_EMAIL="$ARTIFACTORY_EMAIL" \
    -e CONTAINER_NAME="$CONTAINER_NAME" \
    -e DISPLAY=$IP:0 \
    -e GIT_USER_EMAIL="$GIT_USER_EMAIL" \
    -e GIT_USER_NAME="$GIT_USER_NAME" \
    -e HOST_GROUP_ID=$(id -g $USER) \
    -e HOST_PATH=$PWD \
    -e HOST_USER_ID=$(id -u $USER) \
    -e ITERM_PROFILE=$ITERM_PROFILE \
    -e PROJECT_DIR=$PROJECT_DIR \
    -e PROJECT_NAME=$PROJECT_NAME \
    -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    -w ${CONTAINER_HOME}/${PROJECT_DIR} \
    --name $CONTAINER_NAME \
    --net host \
    --privileged \
    nathan-boyd/workbench:latest \
    /opt/entrypoint.sh

# mounting go volumes is slow
#    -v $GO_BIN:$CONTAINER_HOME/go/bin \
#    -v $GO_BUILD_CACHE:$CONTAINER_HOME/.cache/go-build \
#    -v $GO_PKG:$CONTAINER_HOME/go/pkg \
#    -v $PROJECT_GO_BUILD_CACHE:$CONTAINER_HOME/.cache/go-build \
