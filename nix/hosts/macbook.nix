{ inputs, ... }:
{
  # Only this output reads the invoking account; existing hosts remain pure.
  flake.homeConfigurations.macbook = import ../lib/macbook-home.nix { inherit inputs; } {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
  };
}
