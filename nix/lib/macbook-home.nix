{ inputs }:
{ username, homeDirectory }:
let
  system = "aarch64-darwin";
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      (final: _: {
        git-gtr = final.callPackage ../packages/git-gtr.nix {
          src = inputs.git-worktree-runner;
        };
      })
    ];
  };
in
assert username != "" && username != "root";
assert builtins.match "/Users/[^/]+" homeDirectory != null;
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = { inherit inputs; }
    // pkgs.dhallToNix (builtins.readFile ../../host.dhall);
  modules = [
    ../modules/hm-darwin/macbook
    {
      home = {
        inherit username homeDirectory;
        stateVersion = "25.11";
      };
    }
  ];
}
