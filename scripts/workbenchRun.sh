#!/usr/bin/env bash

USER_NAME=$(whoami)
USER_ID=$(id -u ${USER})
GROUP_ID=1001

PROJECT_DIR=${PWD##*/}
PROJECT_PATH=${PWD#"${PWD%/*/*}/"}
PROJECT_NAME=${PROJECT_PATH//\//_}

CONTAINER_NAME="workbench_${PROJECT_NAME}"
CONTAINER_HOME="/home/${USER_NAME}"

XSOCK=/tmp/.X11-unix
DOCKERSOCK=/var/run/docker.sock

echo "*******************************************************************************"
echo "* USER_ID:        $USER_ID"
echo "* GROUP_ID:       $GROUP_ID"
echo "* USER_NAME:      $USER_NAME"
echo "* PROJECT_DIR:    $PROJECT_DIR"
echo "* PROJECT_PATH:   $PROJECT_PATH"
echo "* PROJECT_NAME:   $PROJECT_NAME"
echo "* CONTAINER_NAME: $CONTAINER_NAME"
echo "* CONTAINER_HOME: $CONTAINER_HOME"
echo "*******************************************************************************"

if [ ! -n $(docker ps -a --format '{{ .Names }}' | grep -oE ${CONTAINER_NAME}) ]; then
    echo "workbench already exists!" >&2;
    exit 1;
fi

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

PROJECT_UNDO=${HOME}/.workbench/${PROJECT_NAME}/vim/undodir
if [[ ! -d $PROJECT_UNDO ]]; then
    mkdir -p ${PROJECT_UNDO}
fi

PROJECT_NEOVIM=${HOME}/.workbench/${PROJECT_NAME}/.local/share/shada
if [[ ! -d $PROJECT_NEOVIM ]]; then
    mkdir -p ${PROJECT_NEOVIM}
    touch $PROJECT_NEOVIM/main.shada
fi

PROJECT_NEOMRU=${HOME}/.workbench/${PROJECT_NAME}/.cache/neomru
if [[ ! -d $PROJECT_NEOMRU ]]; then
    mkdir -p ${PROJECT_NEOMRU}
fi

PROJECT_SPACEVIM_PROJECTS=${HOME}/.workbench/${PROJECT_NAME}/.cache/SpaceVim/projects.json
if [[ ! -d $PROJECT_SPACEVIM_PROJECTS ]]; then
    mkdir -p ${PROJECT_SPACEVIM_PROJECTS}
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

#Project config (/home/nboyd/.tmuxinator/git_workbench.yml) doesn't exist.

PROJECT_TMUXINATOR_DIR="${HOME}/.workbench/${PROJECT_NAME}/tmuxinator"
PROJECT_TMUXINATOR_CONFIG="${PROJECT_TMUXINATOR_DIR}/workbench.default.yml"
if [[ ! -d $PROJECT_TMUXINATOR_DIR ]]; then
    mkdir -p ${PROJECT_TMUXINATOR_DIR}
    touch ${PROJECT_TMUXINATOR_CONFIG}
    cat << EOF > "${PROJECT_TMUXINATOR_CONFIG}"
name: $PROJECT_NAME
startup_window: shell
windows:
  - shell:
      layout: main-vertical
      panes:
        - /opt/splashScreen.sh
        - clear && cheat workbench
EOF
fi

ADDITIONAL_VOLUMES_FILE=$HOME/.workbench/.volumes
if test -f "$FILE"; then
    ADDITIONAL_VOLUMES=$(<$ADDITIONAL_VOLUMES_FILE)
fi

read -r -d '' MOUNTED_VOLUMES <<- EOM
      $(eval echo ${ADDITIONAL_VOLUMES}) \
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
      -v $PROJECT_NEOMRU:$CONTAINER_HOME/.cache/neomru \
      -v $PROJECT_AUTOJUMP:$CONTAINER_HOME/.local/share/autojump/ \
      -v $PROJECT_NEOVIM:$CONTAINER_HOME/.local/share/nvim/shada/ \
      -v $PROJECT_COC_SESSIONS:$CONTAINER_HOME/.vim/sessions \
      -v $PROJECT_SESSION:$CONTAINER_HOME/.config/nvim/sessions/ \
      -v $PWD:${CONTAINER_HOME}/${PROJECT_DIR} \
      -v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK \
      -v ${PROJECT_TMUXINATOR_DIR}:$CONTAINER_HOME/.tmuxinator/ \
      -v ${PROJECT_UNDO}:$CONTAINER_HOME/.config/.vim/undodir \
      -v ${PROJECT_NERD_MARKS}:$CONTAINER_HOME/.local/share/nerdtree_bookmarks \
      -v ${ZSH_HISTORY}:$CONTAINER_HOME/.zsh_history \
      -v $XSOCK:$XSOCK \
      -v $DOCKERSOCK:$DOCKERSOCK \
      -v $HOME/.ssh:${CONTAINER_HOME}/.ssh \
      -v /sys/fs/cgroup:/sys/fs/cgroup:ro
EOM

#home/nboyd/.tmuxinator/git_workbench.yml/git_workbench.yml

read -r -d '' ENV_VARS <<- EOM
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
      -e CONTAINER_HOME=$CONTAINER_HOME
EOM

read -r -d '' RUN_COMMAND <<- EOM
    docker run \
      --rm \
      -it \
      ${MOUNTED_VOLUMES} \
      ${ENV_VARS} \
      -w $CONTAINER_HOME/$PROJECT_DIR \
      --name $CONTAINER_NAME \
      --net host \
      --privileged \
      --user $USER_ID:$GROUP_ID \
      docker.io/nathan-boyd/workbench:latest \
      /opt/entrypoint.sh
EOM

eval "$RUN_COMMAND"

