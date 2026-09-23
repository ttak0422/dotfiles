{
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs.yaskkserv2-service.packages.${pkgs.stdenv.hostPlatform.system}) yaskkserv2;
in
{
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 10d";
    };
    settings = {
      # https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = false;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      download-buffer-size = 524288000;
    };
  };
  nixpkgs = {
    overlays = [
      inputs.hyprpanel.overlay
      inputs.brew-nix.overlays.default
      (
        final: prev:
        let
          inherit (prev.stdenv) system;
        in
        {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          zjstatus = inputs.zjstatus.packages.${system}.default;
          git-gtr = final.callPackage ../../packages/git-gtr.nix {
            src = inputs.git-worktree-runner;
          };
          yaskkserv2-dictionary = prev.stdenv.mkDerivation {
            name = "yaskkserv2-dictionary";
            src = inputs.skk-dev-dict;
            # ignore Makefile
            dontBuild = true;
            installPhase = ''
              mkdir $out
              ${yaskkserv2}/bin/yaskkserv2_make_dictionary --dictionary-filename=$out/dictionary.yaskkserv2 SKK-JISYO.L
            '';
            buildInputs = [ ];
          };
        }
      )
    ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ ];
    };
  };
}
