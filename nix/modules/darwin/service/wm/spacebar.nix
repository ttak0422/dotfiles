{ pkgs, ... }:
{
  services.spacebar = {
    enable = true;
    package = pkgs.spacebar;
    config = {
      position = "bottom";
      title = "on";
      spaces = "off";
      clock = "off";
      power = "off";
      height = 26;
      spacing_left = 25;
      spacing_right = 15;
      text_font = ''"PlemolJP Console NF:Bold:14.0"'';
      icon_font = ''"PlemolJP Console NF:Bold:12.0"'';
      background_color = "0xff202020";
      foreground_color = "0xffa8a8a8";
    };
  };
}
