{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib.attrsets) optionalAttrs;
  inherit (inputs.yaskkserv2-service.packages.${pkgs.stdenv.hostPlatform.system}) yaskkserv2;
in
{
  nix = {
    package = pkgs.nixFlakes;
    gc = {
      automatic = true;
      options = "--delete-older-than 10d";
    };
    settings = {
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    } // optionalAttrs isDarwin { extra-platforms = "aarch64-darwin x86_64-darwin"; };
  };
  nixpkgs = {
    overlays = [
      (
        final: prev:
        let
          inherit (prev.stdenv) system;
        in
        {
          pkgs-x86_64-darwin = import inputs.nixpkgs {
            system = "x86_64-darwin";
            config.allowUnfree = true;
          };
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          zjstatus = inputs.zjstatus.packages.${system}.default;
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
