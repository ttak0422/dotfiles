{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      go
      gore
      gcc
    ]
    ++ (
      if pkgs.stdenv.isLinux then
        with pkgs;
        [
          libgcc
        ]
      else
        [ ]
    );
}
