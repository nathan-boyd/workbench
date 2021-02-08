#!/usr/bin/env bash

export TERM=xterm-256color

cat <<-EOF > "$HOME/.gitconfig.append"
# added by workbench
[pager]
    difftool = true
[diff]
    tool = icdiff
[difftool "icdiff"]
    cmd = icdiff --head=5000 --line-numbers -L \"$BASE\" -L \"$REMOTE\" \"$LOCAL\" \"$REMOTE\" --color-map='add:green,change:yellow,description:blue,meta:magenta,separator:blue,subtract:red'
EOF

if ! grep -F -q -f "$HOME/.gitconfig.append" "$HOME/.gitconfig"; then
    cat $HOME/.gitconfig.append >> $HOME/.gitconfig
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
