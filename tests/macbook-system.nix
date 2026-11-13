# nix eval --impure --json --file tests/macbook-system.nix
let
  flake = builtins.getFlake (toString ../.);
  system = import ../nix/lib/macbook-system.nix { inherit (flake) inputs; } {
    username = "example";
    homeDirectory = "/Users/example";
  };
  config = system.config;
  home = config.home-manager.users.example;
  nvim = flake.inputs.dotfiles-nvim.packages.aarch64-darwin."v3/default";
in
assert config.system.primaryUser == "example";
assert config.users.users.example.home == "/Users/example";
assert home.home.stateVersion == "25.11";
assert builtins.elem nvim.drvPath (map (p: p.drvPath) home.home.packages);
assert config.system.defaults.dock.autohide;
assert config.system.defaults.finder.AppleShowAllExtensions;
assert home.home.file."Library/KeyBindings/DefaultKeyBinding.dict".source != null;
assert flake.inputs.nixpkgs.lib.hasInfix "defaults write com.apple.dock"
  config.system.activationScripts.userDefaults.text;
assert !(flake.inputs.nixpkgs.lib.hasInfix "defaults import"
  config.system.activationScripts.userDefaults.text);
assert builtins.all (a: a.assertion) config.assertions;
{
  package = system.system.drvPath;
  inherit (config.system) primaryUser;
}
