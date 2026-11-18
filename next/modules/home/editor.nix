{ inputs, pkgs, ... }:
let
  editors = inputs.dotfiles-nvim.packages.${pkgs.stdenv.hostPlatform.system};
  nvim = editors."v3/default";
  neovideNvim = editors."v3/neovide";
in
{
  # Language runtimes, LSPs and editor configuration belong to dotfiles-nvim.
  # Nix provides the app bundle without installing Homebrew's Neovim dependency.
  home.packages = [ nvim pkgs.neovide ];

  xdg.configFile."neovide/config.toml".text = ''
    frame = "none"
    neovim-bin = "${neovideNvim}/bin/nvim"
  '';
}
