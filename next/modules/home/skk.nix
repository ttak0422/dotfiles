{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.skk;
  address = "127.0.0.1";
  port = "1178";
  azoo = pkgs.callPackage ../../packages/azoo-key-skkserv.nix { };
  yaskkserv2 = inputs.yaskkserv2.packages.${pkgs.stdenv.hostPlatform.system}.yaskkserv2;
  dictionary =
    pkgs.runCommand "yaskkserv2-dictionary"
      {
        nativeBuildInputs = [ yaskkserv2 ];
      }
      ''
        mkdir -p "$out"
        yaskkserv2_make_dictionary --utf8 --dictionary-filename="$out/dictionary.yaskkserv2" \
          ${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L
      '';
  # Both backends accept EUC-JP readings and return UTF-8 candidates.
  command =
    if cfg.useYaskkserv2 then
      [
        "${yaskkserv2}/bin/yaskkserv2"
        # Do not inherit machine-wide Google lookup or network settings.
        "--config-filename=/dev/null"
        "--google-japanese-input=disable"
        "--listen-address=${address}"
        "--port=${port}"
        "--no-daemonize"
        "${dictionary}/dictionary.yaskkserv2"
      ]
    else
      [
        "${azoo}/bin/azoo-key-skkserv"
        "--port"
        port
        "--incoming-charset"
        "EUC-JP"
      ];
  start = pkgs.writeShellScript "start-skk-server" ''
    # A separately managed listener (e.g. the legacy nix-darwin job) is not ours
    # to stop. A backend bind is still the atomic check if another job races us.
    if /usr/bin/nc -z -G 1 ${address} ${port} </dev/null; then
      message="SKK server not started: ${address}:${port} is already in use; stop the other listener to use the dotfiles SKK server."
      printf '%s\n' "$message" >&2
      /usr/bin/logger -t dotfiles-skk "$message"
      exit 1
    fi
    exec ${lib.escapeShellArgs command}
  '';
in
{
  options.dotfiles.skk.useYaskkserv2 = lib.mkEnableOption "yaskkserv2 instead of azoo-key-skkserv (rollback)";

  # The backend is selected once for a single launchd label.
  config.launchd.agents.skk-server = {
    enable = true;
    config = {
      ProgramArguments = [ "${start}" ];
      RunAtLoad = true;
      KeepAlive = true;
      ThrottleInterval = 30;
    };
  };
}
