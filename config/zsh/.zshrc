#source ~/.auth.sh

export ZSH="${HOME}/.oh-my-zsh"

plugins=(
    docker
    git
    history-substring-search
    kubectl
    zsh-autosuggestions
    zsh-syntax-highlighting # must be last plugin
)

source $ZSH/oh-my-zsh.sh

################################################################################

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source /usr/local/powerlevel10k/powerlevel10k.zsh-theme \
    && source "$HOME/.p10k.zsh"

source /usr/share/autojump/autojump.zsh

################################################################################

# enable bash completion (for user when zsh completion doesn't exist)
# required for azure cli completion
autoload -U +X bashcompinit && bashcompinit
source <(kubectl completion zsh)
source /etc/bash_completion.d/azure-cli

source $HOME/.fzf.zsh

export EDITOR='nvim'
export VISUAL=$EDITOR
export PAGER=less
export PATH=$PATH:/usr/local/go/bin
export RANGER_LOAD_DEFAULT_RC=FALSE

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias rn=ranger
alias jp="jq -C | less"
alias c=clear
alias diff=icdiff
alias gdt="git difftool -y"
alias gs="git status"
alias vi=nvim
alias vim=vi
alias mux=tmuxinator
alias muxe=editMuxConfig
alias k=kubectl
alias eee="/opt/workbenchStop.sh"

################################################################################

# if no mux project then create one from template
MUX_PROJECT_FILE=$HOME/.config/tmuxinator/$PROJECT_DIR.yml
if [[ ! -f "$MUX_PROJECT_FILE" ]]; then
    touch $MUX_PROJECT_FILE
    cat /opt/tmuxinator/template.tpl | gomplate > $MUX_PROJECT_FILE
    echo "created mux project from template"
fi

# if starting the shell for the first time then start mux project
FILE=$HOME/.init
if [ ! -f $FILE ]; then
    touch $FILE
    tmuxinator start ${PROJECT_DIR}
fi

################################################################################

function editMuxConfig(){
    vi "$HOME/.config/tmuxinator/$PROJECT_DIR.yml"
}

# clear mux output on source
clear
