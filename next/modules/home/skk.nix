{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.skk;
  azoo = pkgs.callPackage ../../packages/azoo-key-skkserv.nix { };
  yaskkserv2 = inputs.yaskkserv2.packages.${pkgs.stdenv.hostPlatform.system}.yaskkserv2;
  dictionary = pkgs.runCommand "yaskkserv2-dictionary" {
    nativeBuildInputs = [ yaskkserv2 ];
  } ''
    mkdir -p "$out"
    yaskkserv2_make_dictionary --dictionary-filename="$out/dictionary.yaskkserv2" \
      ${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L
  '';
in
{
  options.dotfiles.skk.useYaskkserv2 =
    lib.mkEnableOption "yaskkserv2 instead of azoo-key-skkserv (rollback)";

  config = lib.mkMerge [
    (lib.mkIf (!cfg.useYaskkserv2) {
      launchd.agents.azoo-key-skkserv = {
        enable = true;
        config = {
          ProgramArguments = [
            "${azoo}/bin/azoo-key-skkserv"
            "--port"
            "1179"
            "--incoming-charset"
            "EUC-JP"
          ];
          RunAtLoad = true;
          KeepAlive = true;
        };
      };
    })
    (lib.mkIf cfg.useYaskkserv2 {
      launchd.agents.yaskkserv2 = {
        enable = true;
        config = {
          ProgramArguments = [
            "${yaskkserv2}/bin/yaskkserv2"
            # Do not inherit machine-wide Google lookup or network settings.
            "--config-filename=/dev/null"
            "--google-japanese-input=disable"
            "--listen-address=127.0.0.1"
            "--port=1178"
            "--no-daemonize"
            "${dictionary}/dictionary.yaskkserv2"
          ];
          RunAtLoad = true;
          KeepAlive = true;
        };
      };
    })
  ];
}
