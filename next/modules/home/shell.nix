{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    initContent = ''
      fpath=(${pkgs.pure-prompt}/share/zsh/site-functions $fpath)
      autoload -Uz promptinit
      promptinit
      prompt pure
    '';
  };
  programs.direnv = { enable = true; nix-direnv.enable = true; };
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    fileWidgetCommand = "fd --type f";
    changeDirWidgetCommand = "fd --type d";
  };
  programs.zoxide.enable = true;
}
