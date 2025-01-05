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
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    zsh-abbr.enable = true;
    defaultKeymap = "emacs";
    initExtra =
      readFile ../../../../.zshrc
      + ''
        export PATH="$(rustup show active-toolchain | awk '{print $1}' | xargs -I{} echo ~/.rustup/toolchains/{}/bin):$PATH"
      '';
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
