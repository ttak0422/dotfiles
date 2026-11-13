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
  xdg.configFile."git/committemplate".source = ../../assets/committemplate;
}
