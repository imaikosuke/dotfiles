{ config, pkgs, ... }:

{
  imports = [ ./cursor/cursor.nix ];

  home.username = "imai";
  home.homeDirectory = "/Users/imai";

  # Do not change this value after initial setup.
  home.stateVersion = "25.11";

  # CLI tools managed by Nix.
  home.packages = with pkgs; [
    bat
    fzf
    git
    ghq
    tree
    zsh-completions
  ];

  # Dotfiles symlinked into $HOME.
  home.file = {
    ".gitconfig".source = ./git/.gitconfig;
    ".config/starship.toml".source = ./starship/starship.toml;
    ".config/zsh/.zshrc".source = ./zsh/.zshrc;
    ".config/zsh/aliases.zsh".source = ./zsh/aliases.zsh;
    ".config/zsh/sghq.zsh".source = ./zsh/sghq.zsh;
    ".config/zsh/chpwd.zsh".source = ./zsh/chpwd.zsh;
    ".config/ghostty/config".source = ./ghostty/config;
    ".config/ghostty/banner.txt".source = ./ghostty/banner.txt;
  };

  home.sessionVariables = {};

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    initContent = ''
      source ~/.config/zsh/.zshrc
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.home-manager.enable = true;
}
