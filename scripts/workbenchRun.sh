#!/usr/bin/env bash

set -e

USER_ID=$(id -u ${USER})
GROUP_ID=$(id -g ${USER})
USER_NAME=$(whoami)

PROJECT_DIR=${PWD##*/}
PROJECT_PATH=${PWD#"${PWD%/*/*}/"}
PROJECT_NAME=${PROJECT_PATH//\//_}

CONTAINER_NAME="workbench_${PROJECT_NAME}"
CONTAINER_HOME="/home/$USER_NAME"

# export PROJECT_NAME=${PROJECT_NAME:-"scratch"}

if [ ! -n $(docker ps -a --format '{{ .Names }}' | grep -oE ${CONTAINER_NAME}) ]; then
    echo "workbench already exists!" >&2;
    exit 1;
fi

# Eventually may just mount the .workbench directory and symlink within the container

JRNL_DIR=$HOME/.local/share/jrnl
if [[ ! -d $JRNL_DIR ]]; then
    mkdir -p ${JRNL_DIR}
fi

PROJECT_ZSH=${HOME}/.workbench/${PROJECT_NAME}/zsh
if [[ ! -d $PROJECT_ZSH ]]; then
    mkdir -p ${PROJECT_ZSH}
fi

ZSH_HISTORY=${PROJECT_ZSH}/.zsh_history
if [[ ! -e $ZSH_HISTORY ]]; then
    touch $ZSH_HISTORY
fi

# the directory in which to store vim undo files
PROJECT_UNDO=${HOME}/.workbench/${PROJECT_NAME}/vim/undodir
if [[ ! -d $PROJECT_UNDO ]]; then
    mkdir -p ${PROJECT_UNDO}
fi

# stores vim sessions
PROJECT_COC_SESSIONS=${HOME}/.workbench/${PROJECT_NAME}/.vim/sessions
if [[ ! -d $PROJECT_COC_SESSIONS ]]; then
    mkdir -p ${PROJECT_COC_SESSIONS}
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

PROJECT_NERD_MARKS=${HOME}/.workbench/${PROJECT_NAME}/nerdtree_bookmarks
if [[ ! -d $PROJECT_NERD_MARKS ]]; then
    mkdir -p ${PROJECT_NERD_MARKS}
    touch ${PROJECT_NERD_MARKS}/.NERDTreeBookmarks
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

XSOCK=/tmp/.X11-unix
DOCKERSOCK=/var/run/docker.sock

cat <<-'EOF' > "$HOME/.gitconfig.append"

# added by workbench
[pager]
    difftool = true

[diff]
    tool = icdiff

[difftool "icdiff"]
    cmd = icdiff --head=5000 --line-numbers -L \"$BASE\" -L \"$REMOTE\" \"$LOCAL\" \"$REMOTE\" \
      --color-map='add:green,change:yellow,description:blue,meta:magenta,separator:blue,subtract:red'

[core]
    preloadIndex = true

EOF

if ! grep -F -q -f "$HOME/.gitconfig.append" "$HOME/.gitconfig"; then
    cat $HOME/.gitconfig.append >> $HOME/.gitconfig
fi

PROJECT_TMUXINATOR=${HOME}/.workbench/${PROJECT_NAME}/tmuxinator
if [[ ! -d $PROJECT_TMUXINATOR ]]; then
    mkdir -p ${PROJECT_TMUXINATOR}
    cat << EOF > "$PROJECT_TMUXINATOR/.tmuxinator"
name: $PROJECT_NAME
startup_window: shell
windows:
  - shell:
    - /opt/splashScreen.sh
EOF
fi

docker run \
    --rm \
    -it \
    -v $HOME/.gitconfig:$CONTAINER_HOME/.gitconfig \
    -v $HOME/.gnupg:$CONTAINER_HOME/.gnupg \
    -v $HOME/Desktop/:$CONTAINER_HOME/Desktop \
    -v $HOME/.docker/:$CONTAINER_HOME/.docker/ \
    -v $HOME/.kube/config:$CONTAINER_HOME/.kube/config \
    -v $HOME/.ssh:$CONTAINER_HOME/.ssh \
    -v $HOME/.workbench:$CONTAINER_HOME/.workbench \
    -v $HOME/.local/share/virtualenvs/:$CONTAINER_HOME/.local/share/virtualenvs/ \
    -v $JRNL_DIR:$CONTAINER_HOME/.local/share/jrnl/ \
    -v $LAZY_DOCKER:$CONTAINER_HOME/.config/jesseduffield/lazydocker \
    -v $PROJECT_AUTOJUMP:$CONTAINER_HOME/.local/share/autojump/ \
    -v $PROJECT_COC_SESSIONS:$CONTAINER_HOME/.vim/sessions \
    -v $PROJECT_SESSION:$CONTAINER_HOME/.config/nvim/sessions/ \
    -v $PWD:${CONTAINER_HOME}/${PROJECT_DIR} \
    -v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK \
    -v ${PROJECT_TMUXINATOR}:$CONTAINER_HOME/.config/tmuxinator \
    -v ${PROJECT_UNDO}:$CONTAINER_HOME/.config/.vim/undodir \
    -v ${PROJECT_NERD_MARKS}:$CONTAINER_HOME/.local/share/nerdtree_bookmarks \
    -v ${ZSH_HISTORY}:$CONTAINER_HOME/.zsh_history \
    -v ${PROJECT_TMUXINATOR}/.tmuxinator:${CONTAINER_HOME}/.tmuxinator \
    -v $XSOCK:$XSOCK \
    -v $DOCKERSOCK:$DOCKERSOCK \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    -e DISPLAY=$IP:0 \
    -e CONTAINER_NAME="$CONTAINER_NAME" \
    -e HOST_GROUP_ID=$(id -g $USER) \
    -e HOST_PATH=$PWD \
    -e HOST_USER_ID=$(id -u $USER) \
    -e ITERM_PROFILE=$ITERM_PROFILE \
    -e PROJECT_DIR=$PROJECT_DIR \
    -e PROJECT_NAME=$PROJECT_NAME \
    -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    -e USER=$USER \
    -e TERM=xterm-256color \
    -e CONTAINER_HOME=$CONTAINER_HOME \
    -w $CONTAINER_HOME/$PROJECT_DIR \
    --name $CONTAINER_NAME \
    --net host \
    --privileged \
    --user $USER_ID:$GROUP_ID \
    docker.io/nathan-boyd/workbench:latest \
    tmuxinator start --project-config="$CONTAINER_HOME/.tmuxinator"

# mounting go volumes is slow
#    -v $GO_BIN:$CONTAINER_HOME/go/bin \
#    -v $GO_BUILD_CACHE:$CONTAINER_HOME/.cache/go-build \
#    -v $GO_PKG:$CONTAINER_HOME/go/pkg \
#    -v $PROJECT_GO_BUILD_CACHE:$CONTAINER_HOME/.cache/go-build \
