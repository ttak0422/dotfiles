{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustup
    cargo-binstall
  ];
}
