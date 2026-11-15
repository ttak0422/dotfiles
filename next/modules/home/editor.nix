{ inputs, pkgs, ... }:
let
  nvim = inputs.dotfiles-nvim.packages.${pkgs.stdenv.hostPlatform.system}."v3/default";
in
{
  # Language runtimes, LSPs and editor configuration belong to dotfiles-nvim.
  # Nix provides the app bundle without installing Homebrew's Neovim dependency.
  home.packages = [ nvim pkgs.neovide ];

  # Homebrew's shellenv runs first; also override any previously installed brew nvim.
  programs.zsh.initContent = ''
    path=("${nvim}/bin" $path)
  '';

  xdg.configFile."neovide/config.toml".text = ''
    frame = "none"
    neovim-bin = "${nvim}/bin/nvim"
  '';
}
