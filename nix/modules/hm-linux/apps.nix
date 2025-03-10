{ inputs', pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    ghostty
    inputs'.zen-browser.packages.default
    neovide
    slack
    spotify
    vscode
  ];
  programs.google-chrome.enable = true;
}
