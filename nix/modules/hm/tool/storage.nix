{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      mysql84
      sqlite
    ]
    ++ (
      if pkgs.stdenv.isDarwin then
        [
          # pkgs.pkgs-x86_64-darwin-unstable.oracle-instantclient # sqlplus, ...
        ]
      else
        [ ]
    );
}
