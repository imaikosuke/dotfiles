function _sghq_select() {
  local ghq_root
  local query
  local selected

  query=${1:-}
  ghq_root=$(ghq root)
  selected=$(ghq list --full-path | while IFS= read -r repo; do
    [[ "$repo" == "$ghq_root"/github.com/* ]] && printf '%s\n' "$repo"
  done | fzf --query "$query" --prompt='github > ' --height=40% --reverse) || return 0
  printf '%s\n' "$selected"
}

function sghq() {
  local selected

  selected=$(_sghq_select) || return 0
  cd "$selected" || return
}

function _sghq_widget() {
  local selected

  selected=$(_sghq_select "$LBUFFER") || {
    zle -R -c
    return 0
  }

  BUFFER="cd ${(q)selected}"
  zle accept-line
  zle -R -c
}

zle -N _sghq_widget
bindkey '^G' _sghq_widget
