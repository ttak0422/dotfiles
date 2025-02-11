{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = [ ];
    terminal = "wezterm";
    cycle = true;
  };
}
