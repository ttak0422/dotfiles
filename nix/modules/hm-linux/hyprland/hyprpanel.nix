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
              "media"
              "battery"
              "volume"
              "network"
              "bluetooth"
              "clock"
              "hyprsunset"
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
          media = {
            format = "{artist: - }{title}";
            show_active_only = true;
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
            stats.enable_gpu = false;
            shortcuts.enabled = false;
            powermenu.avatar.image = "~/.config/hypr/avatar.jpg";
          };
          power = {
            lowBatteryNotification = true;
            lowBatteryThreshold = 15;
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
