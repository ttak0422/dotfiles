{ config, lib, pkgs, ... }:
let
  inherit (builtins) readFile;
in
{
  home.packages = with pkgs; [
    bat
    eza
    fzf
    ghq
  ];
  programs.zsh = {
    enable = true;
    # Home Manager owns compinit; keep its default security checks enabled.
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    zsh-abbr.enable = true;
    defaultKeymap = "emacs";
    # zsh-abbr adds this path when sourced, after Home Manager's compinit.
    # Register the same path first so its completion is included in that call.
    initContent = lib.mkOrder 550 ''
      fpath+=("${config.programs.zsh.zsh-abbr.package}/share/zsh/zsh-abbr/completions")
    '';
    initExtra = readFile ../../../../.zshrc;
    envExtra = readFile ../../../../.zshenv;
    profileExtra = readFile ../../../../.zprofile;
    plugins = [
      {
        name = "pure";
        src = pkgs.pure-prompt;
        file = "share/zsh/site-functions";
        completions = [ "share/zsh/site-functions" ];
      }
    ];
  };
}
