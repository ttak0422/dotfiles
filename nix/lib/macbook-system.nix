{ inputs }:
{ username, homeDirectory }:
assert username != "" && username != "root";
assert homeDirectory == "/Users/${username}";
assert builtins.match "[a-zA-Z0-9_][a-zA-Z0-9_-]*" username != null;
inputs.darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = { inherit inputs; user = username; };
  modules = [
    inputs.home-manager.darwinModules.home-manager
    ../modules/darwin/prelude/finder.nix
    ../modules/darwin/prelude/dock.nix
    ../modules/darwin/prelude/ng-global.nix
    ({ pkgs, ... }: {
      system.stateVersion = 6;
      users.users.${username}.home = homeDirectory;
      programs.zsh.enable = true;
      programs.zsh.enableGlobalCompInit = false;
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [
        (final: _: {
          git-gtr = final.callPackage ../packages/git-gtr.nix {
            src = inputs.git-worktree-runner;
          };
        })
      ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; }
          // pkgs.dhallToNix (builtins.readFile ../../host.dhall);
        users.${username} = {
          imports = [ ../modules/hm-darwin/macbook ];
          home = {
            inherit username homeDirectory;
            stateVersion = "25.11";
          };
        };
      };
    })
  ];
}
