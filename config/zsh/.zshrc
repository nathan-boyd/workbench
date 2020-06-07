#source ~/.auth.sh

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

export EDITOR='nvim'
export PAGER=less
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

alias vi=nvim
alias vim=vi
alias mux=tmuxinator

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

################################################################################

MUX_PROJECT_FILE=$HOME/.config/tmuxinator/$PROJECT_DIR.yml
if [[ ! -f "$MUX_PROJECT_FILE" ]]; then
    tmuxinator new $PROJECT_DIR
fi

FILE=$HOME/.init
if [ ! -f $FILE ]; then
    touch $FILE
    tmuxinator start ${PROJECT_DIR}
fi

################################################################################
