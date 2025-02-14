{ inputs', pkgs, ... }:
{
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpanel.nix
    ./keymap.nix
    ./rofi.nix
  ];
  home = {
    file = {
      "panasonic.jpg" = {
        target = ".config/hypr/wallpaper/panasonic.jpg";
        source = pkgs.fetchurl {
          url = "https://content.connect.panasonic.com/jp-ja/fai/47104/raw";
          sha256 = "sha256-JyC+uD0ckzpPMR5PrdeF+CitHfAld8vT2Yy+hOrXm80=";
        };
      };
    };
    packages = with pkgs; [
      hyprcursor
      hyprsunset
      matugen
      # swww
      inputs'.rose-pine-hyprcursor.packages.default
    ];
  };
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      hyprfocus
      hyprspace
    ];
    settings = {
      input.kb_layout = "jp";
      env = [
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
      ];
      exec-once = [
        "hyprlock"
        # "swww init && swww img ~/.config/hypr/wallpaper/panasonic.jpg"
        "fcitx5 -D"
      ];
      monitor = [ "eDP-1, 1920x1280@59.98400, 0x0, 1" ];
      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 3;
      };
      animations = {
        animation = [
          "fade, 0"
        ];
      };
      misc.disable_hyprland_logo = true;
      plugin = {
        hyprfocus = {
          enabled = "yes";
          focus_animation = "flash";
        };
      };
    };
  };
}
