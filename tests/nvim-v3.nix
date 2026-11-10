# Evaluate the shared module and the actual Darwin host without building it:
# nix eval --impure --json --file tests/nvim-v3.nix
let
  flake = builtins.getFlake (toString ../.);
  system = "aarch64-darwin";
  packages = flake.inputs.dotfiles-nvim.packages.${system};
  module = import ../nix/modules/shared/nvim.nix {
    inputs'.dotfiles-nvim = { inherit packages; };
  };
  package = packages."v3/default";
  hostPackages = flake.darwinConfigurations.darwin.config.environment.systemPackages;
in
assert map (p: p.drvPath) module.environment.systemPackages == [ package.drvPath ];
assert builtins.elem package.drvPath (map (p: p.drvPath) hostPackages);
{
  inherit system;
  package = package.drvPath;
}
