{ username, pkgs, ... }:
{
  imports = [ ];
  services.nix-daemon.enable = true;
  system.stateVersion = 5;
  users.users.${username}.home = "/Users/${username}";
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    (runCommand "gsed" { } ''
      mkdir -p $out/bin
      ln -s ${gnused}/bin/sed $out/bin/gsed
    '')
    (runCommand "ggrep" { } ''
      mkdir -p $out/bin
      ln -s ${gnugrep}/bin/grep $out/bin/ggrep
    '')
    (runCommand "gxargs" { } ''
      mkdir -p $out/bin
      ln -s ${findutils}/bin/xargs $out/bin/gxargs
    '')
  ];
}
