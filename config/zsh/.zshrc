TERM="screen-256color"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

################################################################################

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
export RANGER_LOAD_DEFAULT_RC=FALSE

# go path adds
export GO111MODULE=on
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin:$GOBIN
export PATH=$PATH:$HOME/.local/bin

################################################################################
#
# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--bind ctrl-j:down,ctrl-k:up'

################################################################################

alias c="clear"
alias diff="icdiff"
alias ee="/opt/workbenchStop.sh"
alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias gdt="git difftool -y"
alias gs="git status"
alias jp="jq -C | less"
alias k="kubectl"
alias mtr="mtr -t"
alias mux="tmuxinator"
alias muxe="editMuxConfig"
alias pip="pip3"
alias rn="ranger"
alias vi="nvim"
alias vim="vi"
alias docker="sudo docker"

eval "$(pipenv --completion)"

################################################################################

# if no mux project then create one from template
MUX_PROJECT_FILE="$HOME/.config/tmuxinator/$PROJECT_DIR.yml"
if [[ ! -f "$MUX_PROJECT_FILE" ]]; then
    touch $MUX_PROJECT_FILE
    cat /opt/tmuxinator/template.tpl | gomplate > $MUX_PROJECT_FILE
    echo "created mux project from template"
fi

################################################################################

function editMuxConfig(){
    vi "$HOME/.config/tmuxinator/$PROJECT_DIR.yml"
}

################################################################################

export PATH="$PATH:/opt/mssql-tools/bin"

################################################################################
# Sourcing p10k should be the last paart of the zsh
################################################################################

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source /usr/local/powerlevel10k/powerlevel10k.zsh-theme
source "$HOME/.p10k.zsh"

