# Pure wiring regression test; no package builds or network required:
# nix eval --json --file tests/neovide-profile.nix
let
  packages = {
    "v3/default" = "/test/default-editor";
    "v3/neovide" = "/test/neovide-editor";
  };
  next = import ../next/modules/home/editor.nix {
    inputs.dotfiles-nvim.packages.aarch64-darwin = packages;
    pkgs = {
      stdenv.hostPlatform.system = "aarch64-darwin";
      neovide = "/test/neovide-app";
    };
  };
  legacy = import ../nix/modules/hm-darwin/neovide.nix {
    inputs'.dotfiles-nvim = { inherit packages; };
  };
  config = next.xdg.configFile."neovide/config.toml".text;
in
assert next.home.packages == [ packages."v3/default" "/test/neovide-app" ];
assert builtins.match ".*neovim-bin = \"/test/neovide-editor/bin/nvim\".*" config != null;
assert config == legacy.xdg.configFile."neovide/config.toml".text;
{
  terminal = packages."v3/default";
  neovide = packages."v3/neovide";
  inherit config;
}
