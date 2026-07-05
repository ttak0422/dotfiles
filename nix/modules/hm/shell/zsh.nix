{ pkgs, ... }:
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
    enableCompletion = true;
    # Speed up startup: reuse the completion dump and load its compiled .zwc
    # form instead of re-parsing the ~75KB text dump on every launch
    # (~2.3s -> ~0.45s). A full rebuild + audit runs when the dump is >24h old.
    completionInit = ''
      autoload -Uz compinit
      _zdump="$HOME/.zcompdump"
      if [[ -n $_zdump(#qN.mh+24) ]]; then
        compinit -d "$_zdump"
      else
        compinit -C -d "$_zdump"
      fi
      if [[ -s "$_zdump" && ( ! -s "$_zdump.zwc" || "$_zdump" -nt "$_zdump.zwc" ) ]]; then
        zcompile "$_zdump"
      fi
      unset _zdump
    '';
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    zsh-abbr.enable = true;
    defaultKeymap = "emacs";
    initExtra = readFile ../../../../.zshrc;
    envExtra = readFile ../../../../.zshenv;
    profileExtra = readFile ../../../../.zprofile;
    plugins = [
      {
        name = "pure";
        src = pkgs.pure-prompt;
        file = "share/zsh/site-functions";
      }
    ];
  };
}
