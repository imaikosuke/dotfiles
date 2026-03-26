{
  nix-homebrew,
  ...
}:
{
  nix-homebrew = {
    enable = true;
    user = "imai";
    enableRosetta = false;
  };

  homebrew = {
    enable = true;
    user = "imai";
    onActivation = {
      upgrade = true;
      autoUpdate = false;
      cleanup = "uninstall";
    };
    global.autoUpdate = false;

    casks = [
      "google-chrome"
      "slack"
      "obsidian"
      "ghostty"
      "raycast"
      "cursor"
    ];

    brews = [
      "tree"
    ];
  };
}
