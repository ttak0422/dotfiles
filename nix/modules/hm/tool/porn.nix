{ pkgs, ... }:
{
  home.packages = with pkgs; [
    onefetch
    neofetch
  ];
}
