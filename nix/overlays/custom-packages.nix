{ inputs }:
final: _prev:
{
  # Upstream's overlay forwards self.packages and therefore keeps its own pkgs.
  # Reuse its pinned recipe, but build wrappers with the host package set.
  brewCasks = import "${inputs.brew-nix}/casks.nix" {
    pkgs = final;
    brew-api = inputs.brew-api;
  };

  # This input exposes no overlay; keep its recipe and source hash unchanged.
  rose-pine-hyprcursor = final.callPackage "${inputs.rose-pine-hyprcursor}/nix/default.nix" {
    nixpkgs = final;
  };
}
