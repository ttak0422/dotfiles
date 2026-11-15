{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    history = {
      size = 100000;
      save = 1000000;
      ignoreAllDups = true;
      extended = true;
    };
    shellAliases = {
      g = "cd $(ghq root)/$(ghq list | fzf)";
      gg = "ghq get";
    };
    initContent = ''
      setopt no_beep nolistbeep
      setopt hist_reduce_blanks hist_no_store
      setopt auto_pushd pushd_ignore_dups
      setopt list_packed list_types

      fpath=(${pkgs.pure-prompt}/share/zsh/site-functions $fpath)
      autoload -Uz promptinit
      promptinit
      prompt pure
    '';
  };
  programs.direnv = { enable = true; nix-direnv.enable = true; };
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      ai.enabled = false;
      auto_sync = false;
      update_check = false;
      enter_accept = false;
    };
  };
  home.sessionVariables.FZF_CTRL_R_COMMAND = "";
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    fileWidgetCommand = "fd --type f";
    changeDirWidgetCommand = "fd --type d";
  };
  programs.zoxide.enable = true;
}
