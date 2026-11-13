{ pkgs, ... }:
{
  home.packages = with pkgs; [ bat eza fd ripgrep sd htop ];
}
