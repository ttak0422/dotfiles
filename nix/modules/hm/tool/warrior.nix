{ pkgs, ... }:
{
  home.packages = with pkgs; [
    taskwarrior
    taskwarrior-tui
    timewarrior
  ];
}
