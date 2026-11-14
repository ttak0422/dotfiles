{ inputs, username, homeDirectory, ... }:
{
  imports = [
    ../modules/darwin/base.nix
    ../modules/darwin/preferences.nix
    ../modules/darwin/fonts.nix
    ../modules/darwin/apps.nix
  ];
  system.stateVersion = 6;
  system.primaryUser = username;
  users.users.${username}.home = homeDirectory;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.${username} = {
      imports = [ ../profiles/home.nix ];
      home = {
        inherit username homeDirectory;
        stateVersion = "25.11";
      };
    };
  };
}
