{ pkgs, ... }:
{
  imports = [ ];
  xdg = {
    enable = true;
    userDirs.enable = true;
  };
  home = {
    packages = with pkgs; [
      zip
      unzip
      xdg-utils
    ];
  };
}
