#!/bin/bash
export ZSH=~/.oh-my-zsh
export ZSH_CUSTOM=~/.oh-my-zsh/custom
export FZF_PATH=~/.fzf

if [ ! -d $ZSH ]; then
  git clone https://github.com/robbyrussell/oh-my-zsh.git $ZSH
fi

if [ ! -d ${ZSH_CUSTOM}/plugins/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi

if [ ! -d ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi

if [ ! -d ${FZF_PATH} ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ${FZF_PATH}
  ${FZF_PATH}/install
fi

if [ ! -d $ZSH_CUSTOM/plugins/k ]; then
  git clone https://github.com/supercrabtree/k $ZSH_CUSTOM/plugins/k
fi

if [ ! -d $ZSH_CUSTOM/plugins/zsh-output-highlighting ]; then
  git clone https://github.com/l4u/zsh-output-highlighting.git  ${ZSH_CUSTOM}/plugins/zsh-output-highlighting
fi

if [ ! -d $ZSH_CUSTOM/plugins/zsh-vi-mode ]; then
  git clone https://github.com/jeffreytse/zsh-vi-mode \
    $ZSH_CUSTOM/plugins/zsh-vi-mode
fi

ZSH_THEME_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
if [ ! -d "$ZSH_THEME_DIR" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_THEME_DIR"
fi
