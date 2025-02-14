{ pkgs, ... }:
{
  programs = {
    hyprpanel = {
      enable = true;
      systemd.enable = true;
      hyprland.enable = true;
      overwrite.enable = true;
      theme = "everforest";
      layout = {
        "bar.layouts" = {
          "0" = {
            left = [
              "dashboard"
              "workspaces"
            ];
            middle = [ "windowtitle" ];
            right = [
              "battery"
              "volume"
              "network"
              "bluetooth"
              "clock"
              "notifications"
            ];
          };
        };
      };
      # https://hyprpanel.com/configuration/settings.html
      settings = {
        bar = {
          launcher.autoDetectIcon = true;
          workspaces.show_icons = true;
          battery.hideLabelWhenFull = true;
          clock = {
            format = "%m/%d  %H:%M";
            # icon = "";
            showIcon = true;
          };
        };

        menus = {
          clock = {
            time = {
              military = true;
              hideSeconds = true;
            };
            weather.enabled = false;
          };
          dashboard = {
            directories.enabled = false;
            stats.enable_gpu = true;
            shortcuts.enabled = false;
          };
        };
        theme = {
          matugen = true;
          matugen_settings.mode = "light";
          bar.transparent = false;
          bar.location = "bottom";
          font = {
            name = "HackGen Console Regular";
            size = "0.7rem";
          };
        };
        wallpaper = {
          enable = true;
          image = "~/.config/hypr/wallpaper/panasonic.jpg";
        };
      };
    };
  };

}
