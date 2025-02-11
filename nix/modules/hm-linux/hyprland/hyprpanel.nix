{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # bluez
    # bluez-tools
  ];
  programs = {
    hyprpanel = {
      enable = true;
      systemd.enable = true;
      hyprland.enable = true;
      overwrite.enable = true;
      layout = {
        "bar.layouts" = {
          "0" = {
            left = [
              "dashboard"
              "workspaces"
            ];
            middle = [ "media" ];
            right = [
              "volume"
              "battery"
              "notifications"
            ];
          };
        };
      };
      # https://hyprpanel.com/configuration/settings.html
      settings = {
        bar.launcher.autoDetectIcon = true;
        bar.workspaces.show_icons = true;
        menus = {
          clock = {
            time = {
              military = true;
              hideSeconds = true;
            };
            weather.unit = "metric";
          };
          dashboard.directories.enabled = false;
          dashboard.stats.enable_gpu = true;
        };
        theme = {
          bar.transparent = true;
          bar.location = "bottom";
          font = {
            name = "HackGen Console Regular";
            size = "0.8rem";
          };
        };
      };
    };
  };

}
