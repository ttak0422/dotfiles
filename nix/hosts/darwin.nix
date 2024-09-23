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
    {
      darwin = inputs.darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./../modules/shared/prelude.nix
          ./../modules/darwin/prelude
        ];
        specialArgs = {
          inherit self;
          inherit system;
          inherit self';
          inherit inputs';
        } // pkgs.dhallToNix (builtins.readFile ./../../host.dhall);
      };
    }
  );
}
