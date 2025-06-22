{ inputs', pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.runCommand "nvim" { } ''
      mkdir -p $out/bin
      ln -s ${inputs'.dotfiles-nvim.packages.bundler-nvim-v2}/bin/nvim $out/bin/nvim
    '')
  ];
}
