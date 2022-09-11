export ZSH=~/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"
DEFAULT_USER=$(whoami)

plugins=(docker docker-compose git z)

source $ZSH/oh-my-zsh.sh
