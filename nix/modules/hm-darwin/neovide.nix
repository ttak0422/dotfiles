{ inputs', ... }:
{
  xdg.configFile."neovide/config.toml".text = ''
    frame = "none"
    neovim-bin = "${inputs'.dotfiles-nvim.packages."v3/neovide"}/bin/nvim"
  '';
}
