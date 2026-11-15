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
  home.packages = with pkgs; [
    gh
    ghq
    tig # Browse Git history and stage changes interactively.
  ];

  xdg.configFile."tig/config".text = ''
    set main-view = id date author:email-user commit-title:graph=yes,refs=yes
    set main-view-date = custom
    set main-view-date-format = "%y/%m/%d %H:%M"
    set blame-view = date:default author:email-user id:yes,color line-number:yes,interval=1 text
    set pager-view = line-number:yes,interval=1 text
    set stage-view = line-number:yes,interval=1 text
    set log-view = line-number:yes,interval=1 text
    set blob-view = line-number:yes,interval=1 text
    set diff-view = line-number:yes,interval=1 text:yes,commit-title-overflow=no

    # Rebase commits after the selected commit, with confirmation.
    bind main R ?git rebase -i %(commit)
    bind diff R ?git rebase -i %(commit)

    # Keep the existing commit-and-exit workflow.
    bind status C <git commit
  '';
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
