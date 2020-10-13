#!/usr/bin/env bash

export TERM=xterm-256color

USER_NAME=me
USER_GROUP=workbench

if [ ! -z "$GIT_USER_NAME" ] && [ ! -z "$GIT_USER_EMAIL" ]; then
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
fi

# chown mounted volumes here until the following is resolved
# until Add ability to mount volume as user other than root #2259
# https://github.com/moby/moby/issues/2259
echo "performing chown on mounted volumes within container"
find $HOME/ -print | xargs --max-args=5 --max-procs=10000 chown ${USER_NAME}:${USER_GROUP} > /dev/null 2>&1
chown ${USER_NAME}:${USER_GROUP} /usr/lib/node_modules
echo "completed chown"

# if [ -S "/var/run/docker.sock" ]; then
#     USER_GROUP=docker
#     HOST_DOCKER_SOCKET_GROUP_ID=`stat -c %g /var/run/docker.sock`
#
#     echo "USER_NAME: $USER_NAME"
#     echo "USER_GROUP: $USER_GROUP"
#     echo "HOST_DOCKER_SOCKET_GROUP_ID: $HOST_DOCKER_SOCKET_GROUP_ID"
#
#     groupadd --non-unique -g $HOST_DOCKER_SOCKET_GROUP_ID $USER_GROUP
#     usermod -aG $USER_GROUP $USER_NAME
# fi

export PROJECT_NAME=${PROJECT_NAME:-"scratch"}

# other attempts at non root identity within container, keeping around so i dont try again :|
# su -s /bin/tmux -g $USER_GROUP $USER_NAME -- -u -2 new -s ${PROJECT_NAME}
# su -s tmuxinator -g $USER_GROUP $USER_NAME -- start $PROJECT_DIR

su -s /bin/zsh -g $USER_GROUP $USER_NAME
