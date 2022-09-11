export ZSH=~/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"
DEFAULT_USER=$(whoami)

plugins=(
    ag
    docker 
    docker-compose 
    fzf
    git 
    z 
    zsh-autosuggestions
    zsh-syntax-highlighting
    k
)

source $ZSH/oh-my-zsh.sh
