{ config, pkgs, lib, ... }: {
  imports = [
    ./dev
    ./git
    ./scripts
    ./shell
    ./tools
    ./virtualization
    ./nixos/polybar.nix
  ];
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
  home = {
    stateVersion = "21.05";
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    sessionVariables = {
      # sort by name
      # Foo, Bar, Baz -> Bar,Baz, Foo
      EDITOR = "vim";
    };
  };
}
