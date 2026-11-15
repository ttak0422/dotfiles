{ inputs, pkgs, ... }:
let
  nvim = inputs.dotfiles-nvim.packages.${pkgs.stdenv.hostPlatform.system}."v3/default";
in
{
  # Language runtimes, LSPs and editor configuration belong to dotfiles-nvim.
  home.packages = [ nvim ];

  xdg.configFile."neovide/config.toml".text = ''
    frame = "none"
    neovim-bin = "${nvim}/bin/nvim"
  '';
}
