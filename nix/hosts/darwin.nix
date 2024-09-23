{
  self,
  inputs,
  withSystem,
  ...
}:
{
  flake.darwinConfigurations = withSystem "aarch64-darwin" (
    {
      self',
      inputs',
      system,
      pkgs,
      ...
    }:
    let
      # user = builtins.getEnv "USER";
      user = "tak";
      specialArgs =
        {
          inherit self;
          inherit system;
          inherit self';
          inherit inputs';
        }
        // pkgs.dhallToNix (builtins.readFile ./../../host.dhall)
        // {
          inherit user;
        };
    in
    {
      darwin = inputs.darwin.lib.darwinSystem {
        inherit system specialArgs;
        modules = [
          inputs.home-manager.darwinModules.home-manager
          ./../modules/shared/prelude.nix
          ./../modules/shared/nvim.nix
          ./../modules/darwin/prelude

          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              users.${user} = {
                imports = [
                  ./../modules/hm/git.nix
                ];
                home = {
                  username = user;
                  stateVersion = "24.05";
                };
              };
              extraSpecialArgs = specialArgs;
            };
          }
        ];
      };
    }
  );
}
