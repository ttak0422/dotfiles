{ ... }:
{
  imports = [
    ../modules/home/shell.nix
    ../modules/home/git.nix
    ../modules/home/tools.nix
    ../modules/home/editor.nix
    ../modules/home/terminal.nix
  ];
  xdg.enable = true;
}
