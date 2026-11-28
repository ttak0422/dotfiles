{
  stdenvNoCC,
  fetchurl,
  unzip,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "azoo-key-skkserv";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/gitusp/azoo-key-skkserv/releases/download/v${finalAttrs.version}/arm64-apple-macosx-${finalAttrs.version}.zip";
    sha256 = "76dd48cedca6f4fca79cf6c16e647b3e43fc084f668e2cc622cecf31a4e9e20a";
  };

  nativeBuildInputs = [ unzip makeWrapper ];
  dontUnpack = true;
  # Preserve the upstream binary and its sibling Swift resource bundles.
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    unzip -q "$src" 'arm64-apple-macosx/release/*'
    binDir="$out/libexec/azoo-key-skkserv"
    mkdir -p "$binDir" "$out/bin"
    cp -R arm64-apple-macosx/release/. "$binDir/"
    test -x "$binDir/azoo-key-skkserv"
    test -n "$(find "$binDir" -type f -name zenz-v1.gguf -print -quit)"
    makeWrapper "$binDir/azoo-key-skkserv" "$out/bin/azoo-key-skkserv"
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/gitusp/azoo-key-skkserv";
    description = "Local SKK server using AzooKey and Zenzai (upstream binary)";
    mainProgram = "azoo-key-skkserv";
    platforms = [ "aarch64-darwin" ];
  };
})
