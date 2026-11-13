# nix eval --impure --json --file tests/eval.nix
let
  flake = builtins.getFlake (toString ../.);
  system = import ../lib/mk-darwin.nix { inherit (flake) inputs; } {
    username = "example";
    homeDirectory = "/Users/example";
  };
  config = system.config;
  home = config.home-manager.users.example;
in
assert config.system.primaryUser == "example";
assert config.users.users.example.home == "/Users/example";
assert home.home.stateVersion == "25.11";
assert config.system.defaults.dock.autohide;
assert home.programs.zsh.enable;
assert home.programs.git.enable;
assert builtins.elem flake.inputs.dotfiles-nvim.packages.aarch64-darwin."v3/default".drvPath
  (map (p: p.drvPath) home.home.packages);
assert flake.inputs.nixpkgs.lib.hasInfix "defaults write com.apple.dock"
  config.system.activationScripts.userDefaults.text;
assert !(flake.inputs.nixpkgs.lib.hasInfix "defaults import"
  config.system.activationScripts.userDefaults.text);
assert builtins.all (a: a.assertion) config.assertions;
{ package = system.system.drvPath; }
