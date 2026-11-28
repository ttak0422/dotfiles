{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    bat # View files with syntax highlighting.
    eza # List directory contents with richer formatting.
    fd # Find files and directories by name.
    ripgrep # Search file contents with regular expressions.
    sd # Find and replace text using regular expressions.
    nodejs # Node.js runtime, including npm and npx.
    inputs.slk.packages.${pkgs.stdenv.hostPlatform.system}.slk # Slack terminal client.
    htop # Monitor and manage running processes interactively.
  ];

  home.file.".npmrc".text = ''
    prefix = ''${HOME}/.npm-packages
  '';
  home.sessionPath = [ "$HOME/.npm-packages/bin" ];
}
