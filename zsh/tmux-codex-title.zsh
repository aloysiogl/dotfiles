# Descriptive tmux pane title while Codex CLI is running (top pane border).
_codex_tmux_pane_title_preexec() {
  [[ -z "${TMUX:-}" ]] && return 0
  [[ "${DISABLE_AUTO_TITLE:-}" == true ]] && return 0

  emulate -L zsh
  setopt extended_glob

  local cmd="${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}"
  [[ "$cmd" == codex ]] || return 0

  local project=$PWD:t
  local git_root
  git_root=$(command git -C "$PWD" rev-parse --show-toplevel 2>/dev/null)
  [[ -n "$git_root" ]] && project=${git_root:t}

  local label="codex · ${project}"

  local -a args
  args=("${(z)2}")
  if (( ${#args} >= 2 )) && [[ "${args[2]}" != -* ]]; then
    label+=" · ${args[2]}"
  fi

  tmux select-pane -T "$label"
  print -Pn "\ek${(q)label}\e\\"
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _codex_tmux_pane_title_preexec
