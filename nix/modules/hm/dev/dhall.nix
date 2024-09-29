{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dhall
    dhall-bash
    dhall-docs
    dhall-json
    dhall-nix
  ];
}
