{ pkgs, ... }:
{
  home.packages = with pkgs; [
    go
    gore
    gcc
    libgcc
  ];
}
