# List the directory contents automatically when changing directories
function chpwd() {
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
