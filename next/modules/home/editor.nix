{
  config,
  inputs,
  pkgs,
  ...
}:
let
  editors = inputs.dotfiles-nvim.packages.${pkgs.stdenv.hostPlatform.system};
  # The pinned Goda client assumes EUC-JP responses and auto-detects yaskkserv2
  # by process name. The next profile's rollback server instead returns UTF-8.
  withLocalSkk =
    editor:
    if config.dotfiles.skk.useYaskkserv2 then
      pkgs.symlinkJoin {
        name = "${editor.name}-local-skk";
        paths = [ editor ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram "$out/bin/nvim" --set GODA_SKK_SERVER off
        '';
      }
    else
      editor;
  nvim = withLocalSkk editors."v3/default";
  neovideNvim = withLocalSkk editors."v3/neovide";
in
{
  # Language runtimes, LSPs and editor configuration belong to dotfiles-nvim.
  # Nix provides the app bundle without installing Homebrew's Neovim dependency.
  home.packages = [
    nvim
    pkgs.neovide
  ];

  xdg.configFile."neovide/config.toml".text = ''
    frame = "none"
    neovim-bin = "${neovideNvim}/bin/nvim"
  '';
}
