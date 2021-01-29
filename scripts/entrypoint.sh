#!/usr/bin/env bash

export TERM=xterm-256color

if [ ! -z "$GIT_USER_NAME" ] && [ ! -z "$GIT_USER_EMAIL" ]; then
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
fi

export PROJECT_NAME=${PROJECT_NAME:-"scratch"}

# if no mux project then create one from template
MUX_PROJECT_FILE="$HOME/.config/tmuxinator/$PROJECT_DIR.yml"
if [[ ! -f "$MUX_PROJECT_FILE" ]]; then
    touch $MUX_PROJECT_FILE
    cat /opt/tmuxinator/template.tpl | gomplate > $MUX_PROJECT_FILE
    echo "created mux project from template"
fi

# if starting the shell for the first time then start mux project
FILE=$HOME/.init
if [ ! -f $FILE ]; then
    clear
    touch $FILE
    tmuxinator start ${PROJECT_DIR}
fi
