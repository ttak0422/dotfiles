{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    plemoljp-nf # PlemolJP Console NF: Japanese monospace with Nerd Font symbols.
    jetbrains-mono # JetBrains Mono: Latin monospace fallback.
  ];
}
