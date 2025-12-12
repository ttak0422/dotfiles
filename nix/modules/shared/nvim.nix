{ inputs', pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nvim" ''
      exec ${inputs'.dotfiles-nvim.packages.bundler-nvim-v2}/bin/nvim "$@"
    '')
  ];
}
