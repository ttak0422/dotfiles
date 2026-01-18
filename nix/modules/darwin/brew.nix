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
    brews = [ "lunchy" ];
    casks = [
      "discord"
      "firefox"
      "font-plemol-jp"
      "font-plemol-jp-hs"
      "font-plemol-jp-nf"
      "google-chrome"
      "jetbrains-toolbox"
      "karabiner-elements"
      "onedrive"
      "raycast"
      "slack"
      "visual-studio-code"
      "wezterm"
      "zen"
    ];
    onActivation = {
      # cleanup = "zap";
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
