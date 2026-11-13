{ inputs, pkgs, ... }:
{
  # Language runtimes, LSPs and editor configuration belong to dotfiles-nvim.
  home.packages = [ inputs.dotfiles-nvim.packages.${pkgs.stdenv.hostPlatform.system}."v3/default" ];
}
