{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      nodejs_22
    ];
    file.".npmrc".text = ''
      prefix = ''${HOME}/.npm-packages
    '';
  };
}
