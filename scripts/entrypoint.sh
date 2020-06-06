#!/usr/bin/env bash

export TERM=xterm-256color

USER_NAME=me
USER_GROUP=workbench

if [ ! -z "$GIT_USER_NAME" ] && [ ! -z "$GIT_USER_EMAIL" ]; then
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
fi

if [ -S "/var/run/docker.sock" ]; then
    USER_GROUP=docker
    HOST_DOCKER_SOCKET_GROUP_ID=`stat -c %g /var/run/docker.sock`
    groupadd --non-unique -g $HOST_DOCKER_SOCKET_GROUP_ID $USER_GROUP
    usermod -aG $USER_GROUP $USER_NAME
fi

export PROJECT_NAME=${PROJECT_NAME:-"scratch"}

# /bin/zsh
# su -s /bin/zsh -g $USER_GROUP $USER_NAME
# su -s /bin/tmux -g $USER_GROUP $USER_NAME -- -u -2 new -s ${PROJECT_NAME}

su -s /usr/bin/tmux -g $USER_GROUP $USER_NAME --  new-session -d -s ${PROJECT_NAME} -n shell > /dev/null
su -s /usr/bin/tmux -g $USER_GROUP $USER_NAME --  new-window -n editor
su -s /usr/bin/tmux -g $USER_GROUP $USER_NAME --  send-keys -t ${PROJECT_NAME}:shell screenfetch Enter
su -s /usr/bin/tmux -g $USER_GROUP $USER_NAME --  send-keys -t ${PROJECT_NAME}:editor vim Enter
su -s /usr/bin/tmux -g $USER_GROUP $USER_NAME --  attach -t ${PROJECT_NAME}:shell > /dev/null
