#!/usr/bin/env bash

USER_NAME=me
USER_GROUP=workbench

export TERM=xterm-256color
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8

if [ ! -z "$GIT_USER_NAME" ] && [ ! -z "$GIT_USER_EMAIL" ]; then
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
fi

export HOST_USER_ID=${HOST_USER_ID:-`stat -c %u /workspace`}
export HOST_GROUP_ID=${HOST_GROUP_ID:-`stat -c %g /workspace`}

useradd --shell /bin/zsh -u $HOST_USER_ID -g $HOST_GROUP_ID $USER_NAME
echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER_NAME

chown -R me: /home/$USER_NAME

if [ -S "/var/run/docker.sock" ]; then
    HOST_DOCKER_SOCKET_GROUP_ID=`stat -c %g /var/run/docker.sock`
    groupadd --non-unique -g $HOST_DOCKER_SOCKET_GROUP_ID $USER_GROUP
    usermod -aG $USER_GROUP $USER_NAME
fi

export PROJECT_NAME=${PROJECT_NAME:-"scratch"}
su -s /bin/tmux -g $USER_GROUP $USER_NAME -- -u -2 new -s ${PROJECT_NAME}
