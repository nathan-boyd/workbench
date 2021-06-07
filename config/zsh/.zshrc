#export TERM="xterm-256color"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#-------------------------------------------------------------------------------

export ZSH="${HOME}/.oh-my-zsh"

plugins=(
    docker
    gitfast
    history-substring-search
    kubectl
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting # must be last plugin
)

source $ZSH/oh-my-zsh.sh

# if interactive then disable ctrl-s freezing
if [[ -t 0 && $- = *i* ]]
then
    stty -ixon
fi

# enable bash completion (for user when zsh completion doesn't exist)
# autoload -U +X bashcompinit && bashcompinit

source <(kubectl completion zsh)
autoload -U compinit && compinit
_comp_options+=(globdots)

#-------------------------------------------------------------------------------

# initialize autojump
. /usr/share/autojump/autojump.sh

#-------------------------------------------------------------------------------

source $HOME/.fzf.zsh

export EDITOR='nvim'
export VISUAL=$EDITOR
export PAGER=less
export RANGER_LOAD_DEFAULT_RC=FALSE
export PATH=$PATH:/usr/games/

# go path adds
export GO111MODULE=on
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin:$GOBIN
export PATH=$PATH:$HOME/.local/bin

#-------------------------------------------------------------------------------

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--bind ctrl-j:down,ctrl-k:up --height 40% --layout=reverse --border'

# tell the cheat cli to use fzf
export CHEAT_USE_FZF=true

#-------------------------------------------------------------------------------

eval "$(navi widget zsh)"
eval "$(thefuck --alias)"

alias c="clear"
alias ch="cheat"
alias diff="icdiff"
alias ee="tmux kill-server"
alias ff="fuck"
alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias gdt="git difftool -y"
alias gs="git status"
alias gaa="git add -A"
alias gcmsg="git commit -m"
alias gam="gaa && gcmsg"
alias jp="jq -C | less"
alias jr="jrnl"
alias k="kubectl"
alias ld="lazydocker"
alias ll="exa --long --git --all"
alias mtr="mtr -t"
alias mux="tmuxinator"
alias muxe="editMuxConfig"
alias n="navi --query"
alias pip="pip3"
alias rn="ranger"
alias vi="nvim"
alias vim="vi"

complete -F __start_kubectl k


# get a report of jrnl updates for the last 24 hours
alias gsu="/opt/getscrumupdates.sh -d=1"

#-------------------------------------------------------------------------------

function editMuxConfig(){
    vi "$HOME/.config/tmuxinator/$PROJECT_DIR.yml"
}

function watch() { while inotifywait --exclude .swp -e modify -r .; do $@; done; }

#-------------------------------------------------------------------------------
# Sourcing p10k should be the last paart of the zsh
#-------------------------------------------------------------------------------

# fix slow paste
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source $ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme
source "$HOME/.p10k.zsh"
