{ inputs, pkgs, ... }:
let
  # Upstream bumped Cargo.toml without updating its own lock entry.
  lockFileContents = builtins.replaceStrings
    [ "name = \"yaskkserv2\"\nversion = \"0.1.7\"" ]
    [ "name = \"yaskkserv2\"\nversion = \"0.1.8\"" ]
    (builtins.readFile "${inputs.yaskkserv2-src}/Cargo.lock");
  # yaskkserv2 is not packaged in the pinned nixpkgs.
  yaskkserv2 = pkgs.rustPlatform.buildRustPackage {
    pname = "yaskkserv2";
    version = "0.1.8";
    src = inputs.yaskkserv2-src;
    cargoLock = { inherit lockFileContents; };
    postPatch = ''
      cp ${pkgs.writeText "yaskkserv2-Cargo.lock" lockFileContents} Cargo.lock
    '';
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.openssl ];
    cargoBuildFlags = [ "--bin" "yaskkserv2" "--bin" "yaskkserv2_make_dictionary" ];
    # Upstream tests download dictionaries and need network access.
    doCheck = false;
  };
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
