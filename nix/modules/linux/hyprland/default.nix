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
    networkmanagerapplet
  ];
  services = {
    upower.enable = true;
    gvfs.enable = true;
  };
}
