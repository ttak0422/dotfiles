{ inputs', pkgs, ... }:
{
  home.packages = with pkgs; [
    inputs'.zen-browser.packages.default
    discord
    slack
    spotify
    vscode
  ];
  programs.google-chrome.enable = true;
}
