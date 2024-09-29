{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat # ------------ cat clone
    eza # ------------ ls clone
    fd # ------------- find clone
    htop # ----------- top clone
    ripgrep # -------- grep clone
    sd # ------------- sed clone
  ];
}
