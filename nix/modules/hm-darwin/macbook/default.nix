{ inputs, pkgs, ... }:
{
  imports = [
    ../../hm/git
    ../../hm/tool/gnu.nix
    ../../hm/tool/yet-another.nix
    ../../hm/shell
    ../wezterm.nix
  ];

  programs.home-manager.enable = true;
  xdg.enable = true;
  home.packages = with pkgs; [
    fd
    ripgrep
    gh
    git
    inputs.dotfiles-nvim.packages.${pkgs.stdenv.hostPlatform.system}."v3/default"
  ];

  # Development tools and editor configuration stay in dotfiles-nvim.
  home.file."Library/KeyBindings/DefaultKeyBinding.dict".source =
    ../../../../Library/KeyBindings/DefaultKeyBinding.dict;
}
