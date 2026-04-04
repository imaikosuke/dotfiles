{
  self,
  pkgs,
  username,
  system,
  ...
}:
{
  users.users.${username}.home = "/Users/${username}";
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
  nix.enable = false;
  security.pam.services.sudo_local.touchIdAuth = true;
  system.configurationRevision = self.rev or self.dirtyRev or null;
}
