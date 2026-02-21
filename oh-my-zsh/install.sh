#!/bin/bash
export ZSH=~/.oh-my-zsh
export ZSH_CUSTOM=~/.oh-my-zsh/custom
export FZF_PATH=~/.fzf
ZSH_VI_MODE_ORIGIN="https://github.com/aloysiogl/zsh-vi-mode.git"
ZSH_VI_MODE_UPSTREAM="https://github.com/jeffreytse/zsh-vi-mode"

if [ ! -d $ZSH ]; then
  git clone https://github.com/robbyrussell/oh-my-zsh.git $ZSH
fi

if [ ! -d ${ZSH_CUSTOM}/plugins/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi

if [ ! -d ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi

if [ ! -d ${ZSH_CUSTOM}/plugins/zsh-autocomplete ]; then
  git clone https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM}/plugins/zsh-autocomplete
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
  git clone "$ZSH_VI_MODE_ORIGIN" $ZSH_CUSTOM/plugins/zsh-vi-mode
fi

if [ -d $ZSH_CUSTOM/plugins/zsh-vi-mode/.git ]; then
  cd $ZSH_CUSTOM/plugins/zsh-vi-mode

  git remote set-url origin "$ZSH_VI_MODE_ORIGIN"
  if ! git remote get-url upstream >/dev/null 2>&1; then
    git remote add upstream "$ZSH_VI_MODE_UPSTREAM"
  fi

  git fetch origin
  git fetch upstream

  # Try to fast-forward to upstream
  git checkout master >/dev/null 2>&1
  if ! git merge --ff-only upstream/master >/dev/null 2>&1; then
    echo "WARNING: Could not fast-forward to upstream/master. Manual merge may be required."
  fi

  # Warn if upstream does not contain local fork changes
  if ! git merge-base --is-ancestor origin/master upstream/master; then
    echo "WARNING: Upstream does not contain your fork's master changes."
  fi
fi

ZSH_THEME_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
if [ ! -d "$ZSH_THEME_DIR" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_THEME_DIR"
fi
