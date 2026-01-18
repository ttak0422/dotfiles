{ pkgs, ... }:
{
  imports = [
    ./gnu.nix
    ./nix.nix
    ./porn.nix
    ./storage.nix
    ./warrior.nix
    ./yet-another.nix
  ];
  home.packages = with pkgs; [
    ast-grep # ------- structural grep
    bottom # --------- system monitor
    d2 # ------------- modern diagram
    figlet # --------- ascii
    graphviz # ------- dot
    grex # ----------- derive regex from examples
    hey # ------------ load test tool
    jq # ------------- JSON processor
    mkcert # --------- create local CA
    peco # ----------- interactive filtering
    plantuml # ------- uml
    pwgen # ---------- password generator
    rlwrap # --------- readline wrapper
    tealdeer # ------- tldr: complete `man` command
    tokei # ---------- code count
    yq # ------------- YAML/XML/TOML processor
    vhs # ------------ Tool for generating terminal GIFs with code
  ];
}
