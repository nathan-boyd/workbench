#source ~/.auth.sh

export TERM="xterm-256color"

export ZSH="${HOME}/.oh-my-zsh"

plugins=(
    colorize
    git
    history-substring-search
    kubectl
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
  alias vim="nvim"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source "$HOME/.p10k.zsh"
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

export PAGER=less

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
