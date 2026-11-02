# Evaluate without building a host system:
# nix eval --impure --json --file tests/nixpkgs-sharing.nix
let
  flake = builtins.getFlake (toString ../.);
  inherit (flake) inputs;
  system = "aarch64-darwin";
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [ (import ../nix/overlays/custom-packages.nix { inherit inputs; }) ];
  };
  package = pkgs.brewCasks.neovide-app;
  upstream = inputs.brew-nix.packages.${system}.neovide-app;
in
assert package.stdenv.drvPath == pkgs.stdenvNoCC.drvPath;
assert package.src.outPath == upstream.src.outPath;
assert package.version == upstream.version;
assert builtins.elem pkgs._7zz.drvPath (map (p: p.drvPath) package.nativeBuildInputs);
{
  inherit system;
  package = package.drvPath;
  hostStdenv = pkgs.stdenvNoCC.drvPath;
}
