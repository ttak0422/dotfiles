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
          inherit system;
          inherit self;
          inherit inputs;
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
          ./../modules/darwin/service/wm
          ./../modules/darwin/service/skk.nix
          ./../modules/darwin/brew.nix
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              users.${user} = {
                imports = [
                  ./../modules/hm-darwin/neovide.nix
                  ./../modules/hm-darwin/prelude.nix
                  ./../modules/hm-darwin/wezterm.nix
                  ./../modules/hm/dev
                  ./../modules/hm/git
                  ./../modules/hm/shell
                  ./../modules/hm/tool
                ];
                home = {
                  username = user;
                  stateVersion = "24.11";
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
