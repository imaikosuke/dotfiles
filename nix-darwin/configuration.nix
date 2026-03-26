{
  self,
  ...
}:
{
  users.users."imai".home = "/Users/imai";
  imports = [
    ./home_manager.nix
    ./homebrew.nix
  ];
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  nix.enable = false;
  security.pam.services.sudo_local.touchIdAuth = true;
  system.configurationRevision = self.rev or self.dirtyRev or null;
}
