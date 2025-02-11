_: {
  imports = [ ./greetd.nix ];
  programs = {
    hyprland.enable = true;
    hyprlock.enable = true;
  };
  services = {
    upower.enable = true;
  };
}
