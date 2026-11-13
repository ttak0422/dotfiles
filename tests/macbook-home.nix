# nix eval --impure --json --file tests/macbook-home.nix
let
  flake = builtins.getFlake (toString ../.);
  home = import ../nix/lib/macbook-home.nix { inherit (flake) inputs; } {
    username = "example";
    homeDirectory = "/Users/example";
  };
  config = home.config;
  nvim = flake.inputs.dotfiles-nvim.packages.aarch64-darwin."v3/default";
in
assert config.home.username == "example";
assert config.home.homeDirectory == "/Users/example";
assert config.home.stateVersion == "25.11";
assert builtins.elem nvim.drvPath (map (p: p.drvPath) config.home.packages);
assert config.targets.darwin.defaults."com.apple.dock".autohide;
assert config.targets.darwin.defaults."com.apple.finder".AppleShowAllExtensions;
assert config.home.file."Library/KeyBindings/DefaultKeyBinding.dict".source != null;
assert builtins.all (a: a.assertion) config.assertions;
{
  package = home.activationPackage.drvPath;
  inherit (config.home) username homeDirectory;
}
