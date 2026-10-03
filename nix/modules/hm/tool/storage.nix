{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mysql84
    sqlite
  ];
}
