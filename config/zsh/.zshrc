#source ~/.auth.sh

function editMuxConfig(){
    vi "$HOME/.config/tmuxinator/$PROJECT_DIR.yml"
}

export ZSH="${HOME}/.oh-my-zsh"

plugins=(
    colorize
    git
    history-substring-search
    kubectl
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
source /usr/local/powerlevel10k/powerlevel10k.zsh-theme
source "$HOME/.p10k.zsh"

################################################################################

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export EDITOR='nvim'
export PAGER=less
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export GOENV_ROOT="/usr/local/.goenv"

# setup golang
export PATH=$PATH:/usr/local/go/bin

alias vi=nvim
alias vim=vi
alias mux=tmuxinator
alias muxe=editMuxConfig

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
