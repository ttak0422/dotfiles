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
  imports = [ ./tig.nix ];
  home = {
    packages = with pkgs; [
      delta
      gh
      ghq
      git
      git-lfs
      git-secrets
      pre-commit
      # gitu
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
