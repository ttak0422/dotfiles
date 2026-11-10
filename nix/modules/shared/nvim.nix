{ inputs', ... }:
{
  # The complete upstream profile is available on aarch64-darwin only.
  environment.systemPackages = [ inputs'.dotfiles-nvim.packages."v3/default" ];
}
