#!/usr/bin/env bash

export TERM=xterm-256color

cat <<-'EOF' > "$HOME/.gitconfig.append"
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

tmuxinator start --project-config ~/.tmuxinator/workbench.default.yml
