{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      core = { editor = "nvim"; autocrlf = false; quotepath = false; };
      init.defaultBranch = "main";
      rerere.enabled = true;
      credential.helper = "osxkeychain";
      commit.template = "${config.xdg.configHome}/git/committemplate";
    };
    includes = [ { path = "~/.config/git/identity"; } ];
  };
  programs.delta = { enable = true; enableGitIntegration = true; };
  home.packages = with pkgs; [ gh ghq ];
  xdg.configFile."git/committemplate".text = ''


    # = HEADER =================================================
    #
    # build: ---------------- changes that affect artifacts
    # feat: ----------------- add new feature
    # chore: ---------------- maintenance
    # fix: ------------------ bug fix
    # refactor: ------------- refactor
    # test: ----------------- test
    # style: ---------------- formatting
    # docs: ----------------- documents
    # perf: ----------------- improve performance
    # ci: ------------------- ci
    #
    # <type>(<scope>): <short summary>
    #   │       │             │
    #   │       │             └─> Summary in present tense.
    #   │       │                 Not capitalized.
    #   │       │                 No period at the end.
    #   │       │
    #   │       └─> Commit Scope: common|core|logic|...
    #   │
    #   └─> Commit Type: build|feat|chore|...
    #
    # = FOOTER (if exists) =====================================
    #
    # - BREAKING CHANGE: <breaking change summary>
    # - DEPRECATED: <what is deprecated>
    #
    # ==========================================================
  '';
}
