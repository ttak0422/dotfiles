{ pkgs, ... }:
{
  services.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;
    config = ''
      sketchybar --bar height=38
      sketchybar --update
    '';
  };
}
