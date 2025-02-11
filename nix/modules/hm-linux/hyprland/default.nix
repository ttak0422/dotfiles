{ inputs', pkgs, ... }:
{
  imports = [
    ./hyprlock.nix
    ./keymap.nix
    ./rofi.nix
    ./waybar.nix
  ];
  home.packages = [
    pkgs.hyprcursor
    inputs'.rose-pine-hyprcursor.packages.default
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [ ];
    settings = {
      input.kb_layout = "jp";
      env = [
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
      ];
      exec-once = [
        "hyprlock"
        "fcitx5 -D"
      ];
      monitor = [ "eDP-1, 1920x1280@59.98400, 0x0, 1" ];
      misc.disable_hyprland_logo = true;
    };
  };
}
