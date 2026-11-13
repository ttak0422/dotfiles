{ inputs, ... }:
{
  # Explicit variables survive sudo without relying on root's USER or HOME.
  flake.darwinConfigurations.macbook = import ../lib/macbook-system.nix { inherit inputs; } {
    username = builtins.getEnv "DOTFILES_USERNAME";
    homeDirectory = builtins.getEnv "DOTFILES_HOME";
  };
}
