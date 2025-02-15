{ pkgs, ... }:
{
  imports = [ ./greetd.nix ];
  programs = {
    hyprland.enable = true;
    hyprlock.enable = true;
  };
  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
    blueman
    libgtop
    dart-sass
    wl-clipboard
    cliphist
  ];
  services = {
    upower.enable = true;
    gvfs.enable = true;
  };
}
