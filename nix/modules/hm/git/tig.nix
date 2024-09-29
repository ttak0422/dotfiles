{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ tig ];
    file.".config/tig/config".text = builtins.readFile ./../../../../tig/config;
  };
}
