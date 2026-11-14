{ ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
  # Home Manager initializes completion using the assembled user fpath.
  programs.zsh.enableGlobalCompInit = false;
}
