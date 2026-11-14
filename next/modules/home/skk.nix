{ inputs, pkgs, ... }:
let
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
}
