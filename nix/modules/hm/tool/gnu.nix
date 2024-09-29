{ pkgs, ... }:
{
  home.packages = with pkgs; [
    coreutils-full # - cat, ls, mv, wget, ...
    gnugrep
    gnumake
    findutils # ------ GNU find, xargs, locate, updatedb
    gnused
  ];
}
