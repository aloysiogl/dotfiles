export ZSH=~/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"
DEFAULT_USER=$(whoami)

plugins=(
    ag
    docker 
    docker-compose 
    fzf
    git 
    # z 
    zsh-vi-mode
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-output-highlighting
    k
)

source $ZSH/oh-my-zsh.sh
