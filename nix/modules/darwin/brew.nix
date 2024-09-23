{
  user,
  inputs,
  ...
}:
let
  inherit (inputs)
    homebrew-core
    homebrew-cask
    homebrew-cask-fonts
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
      "homebrew/homebrew-cask-fonts" = homebrew-cask-fonts;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };
    mutableTaps = false;
  };
  homebrew = {
    enable = true;
    taps = builtins.attrNames nix-homebrew.taps;
    brews = [ "lunchy" ];
    casks = [
      "aquaskk"
      "font-plemol-jp"
      "font-plemol-jp-hs"
      "font-plemol-jp-nf"
      "google-chrome"
      "firefox"
    ];
    onActivation = {
      cleanup = "zap";
    };
    global = {
      brewfile = true;
    };
  };
}
