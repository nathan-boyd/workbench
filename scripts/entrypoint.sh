#!/usr/bin/env bash

export TERM=xterm-256color
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8

# setup git
if [ ! -z "$GIT_USER_NAME" ] && [ ! -z "$GIT_USER_EMAIL" ]; then
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
fi

export HOST_USER_ID=${HOST_USER_ID:-`stat -c %u /workspace`}
export HOST_GROUP_ID=${HOST_GROUP_ID:-`stat -c %g /workspace`}

useradd --shell /bin/zsh -u $HOST_USER_ID -g $HOST_GROUP_ID me

# make you me, right? yeah thats right.
chown -R me: /home/me

if [ -S "/var/run/docker.sock" ]; then
    HOST_DOCKER_SOCKET_GROUP_ID=`stat -c %g /var/run/docker.sock`
    groupadd --non-unique -g $HOST_DOCKER_SOCKET_GROUP_ID workbench
    usermod -aG workbench me
fi

usermod -aG sudo me
echo "Set disable_coredump false" >> /etc/sudo.conf

export PROJECT_NAME=${PROJECT_NAME:-"scratch"}
su -s /bin/tmux -g workbench me -- -u -2 new -s ${PROJECT_NAME}
