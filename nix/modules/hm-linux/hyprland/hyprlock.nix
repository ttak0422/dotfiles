{ pkgs, ... }:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        blur_passes = 3;
        contrast = 0.9;
        brightness = 0.9;
        vibrancy = 0.9;
        vibrancy_darkness = 0;
      };
      general = {
        no_fade_in = false;
        grace = 0;
        disable_loading_bar = false;
      };

      label = [
        {
          monitor = "";
          text = "$USER";
          color = "rgba(255, 255, 255, .65)";
          font_size = 25;
          font_family = "HackGen";
          position = "0, -70";
          halign = "center";
          valign = "center";
        }
      ];
      input-field = {
        monitor = "";
        font_family = "HackGen";
        size = "290, 60";
        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(60, 56, 54, 0.35)";
        font_color = "rgb(200, 200, 200)";
        fade_on_empty = false;
        placeholder_text = ''<i><span foreground="##ffffff99">Password</span></i>'';
        hide_input = false;
        position = "0, -140";
        halign = "center";
        valign = "center";
      };
    };
  };
}
