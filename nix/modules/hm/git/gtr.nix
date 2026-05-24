{ pkgs, ... }:
{
  home.packages = [ pkgs.git-gtr ];
  programs.zsh.initContent = ''
    source ${pkgs.git-gtr}/share/git-gtr/init.zsh
  '';
}
