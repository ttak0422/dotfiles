{ inputs', pkgs, ... }:
{
  home.packages = with pkgs; [
    inputs'.zen-browser.packages.default
    vscode
    spotify
  ];
  programs.google-chrome.enable = true;
}
