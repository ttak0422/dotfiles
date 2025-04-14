{ inputs', pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    ghostty
    inputs'.zen-browser.packages.default
    jetbrains-toolbox
    neovide
    slack
    spotify
    vscode
  ];
  programs.google-chrome.enable = true;
}
