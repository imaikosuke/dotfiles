# List the directory contents automatically when changing directories
function chpwd() {
  # Skip in non-interactive shells (scripts, AI agents, etc.)
  [[ -o interactive ]] || return

  # Skip when running inside Cursor's AI agent shell. TERM_PROGRAM may be
  # inherited from the parent terminal (e.g. ghostty) so it can't be used alone.
  [[ -n "$CURSOR_AGENT" ]] && return
  [[ -n "$VSCODE_INJECTION" ]] && return

  # Only run in Ghostty terminal
  if [[ "$TERM_PROGRAM" != "ghostty" ]]; then
    return
  fi

  case "$PWD" in
    "$HOME"|"$HOME/Applications"|"$HOME/Documents"|"$HOME/Downloads"|"$HOME/Library")
      return
      ;;
    *)
      ls -laG
      ;;
  esac
}
