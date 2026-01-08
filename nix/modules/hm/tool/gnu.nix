{ pkgs, ... }:
{
  home.packages = with pkgs; [
    coreutils-full # - cat, ls, mv, wget, ...
    findutils # ------ GNU find, xargs, locate, updatedb
    gnugrep
    gnumake
    gnused
    wget
  ];
}
