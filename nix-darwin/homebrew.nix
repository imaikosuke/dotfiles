{
  nix-homebrew,
  username,
  ...
}:
{
  nix-homebrew = {
    enable = true;
    user = username;
    enableRosetta = false;
  };

  homebrew = {
    enable = true;
    user = username;
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

    brews = [ ];
  };
}
