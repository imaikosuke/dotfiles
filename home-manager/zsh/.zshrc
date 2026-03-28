source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/sghq.zsh
source ~/.config/zsh/chpwd.zsh

# Show a Ghostty-only startup banner using the Tokyo Night blue accent.
if [[ -o interactive && "$TERM_PROGRAM" == "ghostty" && -r ~/.config/ghostty/banner.txt ]]; then
  echo -e "\033[38;2;122;162;247m"
  cat ~/.config/ghostty/banner.txt
  echo -e "\033[0m"
fi
