{
  user,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs)
    homebrew-core
    homebrew-cask
    homebrew-bundle
    ;
in
rec {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];
  nix-homebrew = {
    inherit user;
    enable = true;
    enableRosetta = true;
    # nix-homebrew derives this metadata from its own, unoverridden lock file.
    package = inputs.nix-homebrew.inputs.brew-src // {
      name = "brew-7.0.9";
      version = "7.0.9";
    };
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };
    mutableTaps = false;
  };
  homebrew = {
    enable = true;
    taps = builtins.attrNames nix-homebrew.taps;
    brews = [
      "ca-certificates"
      "lunchy"
    ];
    casks = [
      "discord"
      "firefox"
      "font-plemol-jp"
      "font-plemol-jp-hs"
      "font-plemol-jp-nf"
      "font-sf-mono"
      "google-chrome"
      "jetbrains-toolbox"
      "karabiner-elements"
      "onedrive"
      "raycast"
      "slack"
      {
        name = "visual-studio-code";
        # Include VS Code even though its cask declares auto_updates.
        greedy = true;
      }
      "wezterm"
    ];
    onActivation = {
      upgrade = true;
    };
    global = {
      brewfile = true;
    };
  };
  # experimental
  environment.systemPackages = with pkgs.brewCasks; [
    neovide-app
  ];
}
