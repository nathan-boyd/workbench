#source ~/.auth.sh

export ZSH="${HOME}/.oh-my-zsh"

FILE=$HOME/.init
if [ ! -f $FILE ]; then
    touch $FILE
    tmuxinator start ${PROJECT_DIR}
fi

plugins=(
    colorize
    git
    history-substring-search
    kubectl
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'
alias vi=nvim

alias mux=tmuxinator

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
source /usr/local/powerlevel10k/powerlevel10k.zsh-theme
source "$HOME/.p10k.zsh"

export PAGER=less
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
