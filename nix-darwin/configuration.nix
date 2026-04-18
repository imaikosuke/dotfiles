{
  self,
  pkgs,
  username,
  system,
  ...
}:
{
  users.users.${username}.home = "/Users/${username}";
  system.primaryUser = username;
  imports = [
    ./home_manager.nix
    ./homebrew.nix
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = system;
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
  system.stateVersion = 6;

  system.defaults = {
    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXPreferredViewStyle = "clmv";
      _FXShowPosixPathInTitle = true;
    };

    NSGlobalDomain = {
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      ApplePressAndHoldEnabled = false;

      "com.apple.trackpad.scaling" = 3.0;
      "com.apple.mouse.tapBehavior" = 1;

      AppleInterfaceStyle = "Dark";

      NSTableViewDefaultSizeMode = 1;
    };

    trackpad = {
      Clicking = true;
    };

    screencapture = {
      location = "~/Pictures/Screenshots";
      type = "png";
      disable-shadow = true;
    };

    dock = {
      show-recents = false;
      autohide = true;
    };

    CustomUserPreferences = {
      NSGlobalDomain = {
        TISRomanSwitchState = 1;
      };
    };
  };

  nix.enable = false;
  security.pam.services.sudo_local.touchIdAuth = true;
  system.configurationRevision = self.rev or self.dirtyRev or null;
}
