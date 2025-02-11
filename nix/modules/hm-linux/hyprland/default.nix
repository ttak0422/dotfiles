{ inputs', pkgs, ... }:
{
  imports = [
    ./keymap.nix
    ./rofi.nix
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
      misc.disable_hyprland_logo = true;
    };
  };
}
