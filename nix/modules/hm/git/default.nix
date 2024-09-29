{
  username,
  email,
  pkgs,
  ...
}:
let
  gitConfig = pkgs.dhallToNix (builtins.readFile ./../../../../git/config.dhall);
  configDir = ".config/git";
in
{
  home = {
    packages = with pkgs; [
      delta
      gh
      ghq
      git
      git-lfs
      git-secrets
      pre-commit
    ];
    file = {
      "${configDir}/config".text = ''
        ${gitConfig {
          inherit email configDir;
          inherit (pkgs.stdenv) isDarwin;
          name = username;
        }}
      '';
      "${configDir}/ignore".text = builtins.readFile ./../../../../git/ignore;
      "${configDir}/committemplate".text = builtins.readFile ./../../../../git/committemplate;
    };
  };
}
