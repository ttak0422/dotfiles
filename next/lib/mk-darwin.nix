{ inputs }:
{ username, homeDirectory }:
assert username != "" && username != "root";
assert homeDirectory == "/Users/${username}";
assert builtins.match "[a-zA-Z0-9_][a-zA-Z0-9_-]*" username != null;
inputs.darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = { inherit inputs username homeDirectory; };
  modules = [
    inputs.home-manager.darwinModules.home-manager
    ../hosts/macbook.nix
  ];
}
