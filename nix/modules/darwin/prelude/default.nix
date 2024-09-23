{ user, pkgs, ... }:
{
  imports = [ ];
  services.nix-daemon.enable = true;
  system.stateVersion = 5;
  users.users.${user}.home = "/Users/${user}";
  users.users.nix-infra.home = "/Users/${user}";
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
