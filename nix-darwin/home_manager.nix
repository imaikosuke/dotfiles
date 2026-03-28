{ username, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit username;
  };
  home-manager.users.${username} = ../home-manager/home.nix;
}
