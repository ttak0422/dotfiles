{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat # View files with syntax highlighting.
    eza # List directory contents with richer formatting.
    fd # Find files and directories by name.
    ripgrep # Search file contents with regular expressions.
    sd # Find and replace text using regular expressions.
    nodejs # Node.js runtime, including npm and npx.
    htop # Monitor and manage running processes interactively.
  ];
}
