{ pkgs, username, ... }:

{
  imports = [
    ./cursor/cursor.nix
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # Do not change this value after initial setup.
  home.stateVersion = "25.11";

  # CLI tools managed by Nix.
  home.packages = with pkgs; [
    bat
    claude-code
    git
    ghq
    tree
    zsh-completions
  ];

  # Dotfiles symlinked into $HOME.
  home.file = {
    ".gitconfig".source = ./git/.gitconfig;
    ".config/starship.toml".source = ./starship/starship.toml;
    ".config/zsh" = {
      source = ./zsh;
      recursive = true;
    };
    ".config/ghostty/config".source = ./ghostty/config;
    ".config/ghostty/banner.txt".source = ./ghostty/banner.txt;
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      initContent = ''
        source ~/.config/zsh/.zshrc
      '';
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    mise = {
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    home-manager.enable = true;
  };
}
