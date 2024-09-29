_: {
  programs.mcfly = {
    enable = true;
    fzf.enable = true;
    keyScheme = "vim";
    fuzzySearchFactor = 2;
    interfaceView = "BOTTOM";
  };
  home.sessionVariables = {
    MCFLY_RESULTS = "50";
    MCFLY_DELETE_WITHOUT_CONFIRM = "true";
    MCFLY_PROMPT = "❯";
  };
}
