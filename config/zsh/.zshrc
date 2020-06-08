#source ~/.auth.sh

function editMuxConfig(){
    vi "$HOME/.config/tmuxinator/$PROJECT_DIR.yml"
}

export ZSH="${HOME}/.oh-my-zsh"

plugins=(
docker
    colorize
    git
    history-substring-search
    kubectl
    zsh-autosuggestions
    zsh-syntax-highlighting # must be last plugin
)

source $ZSH/oh-my-zsh.sh

################################################################################

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
source /usr/local/powerlevel10k/powerlevel10k.zsh-theme
source "$HOME/.p10k.zsh"

################################################################################

# todo remove if
if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi
if [ helm ]; then source <(helm completion zsh); fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export EDITOR='nvim'
export PAGER=less
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# required for fzf file finding in vim
#export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# include hidden files in search
export FZF_DEFAULT_COMMAND='rg --hidden -l --ignore .git ""'


export GOENV_ROOT="/usr/local/.goenv"

# setup golang
export PATH=$PATH:/usr/local/go/bin

alias vi=nvim
alias vim=vi
alias mux=tmuxinator
alias muxe=editMuxConfig
alias k=kubectl

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

ls='ls --color=tty'
grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'

################################################################################

MUX_PROJECT_FILE=$HOME/.config/tmuxinator/$PROJECT_DIR.yml
if [[ ! -f "$MUX_PROJECT_FILE" ]]; then
    touch $MUX_PROJECT_FILE
    cat /opt/tmuxinator/template.tpl | gomplate > $MUX_PROJECT_FILE
fi

FILE=$HOME/.init
if [ ! -f $FILE ]; then
    touch $FILE
    tmuxinator start ${PROJECT_DIR}
fi

################################################################################
