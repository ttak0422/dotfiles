final: prev:
let
  java21 = prev.jdk21.override {
    dists.aarch64-darwin = {
      jdkVersion = "21.0.13";
      zuluVersion = "21.54.107";
      hash = "sha256-doL8u8OhZDUtNsCclrKqkYQci7r9uamn9fBNttKQpiQ=";
    };
  };
in
{
  gradle =
    (prev.gradle-packages.mkGradle {
      version = "8.14.6";
      hash = "sha256-eYjtBxsqB5AOLscV/KFcarcrzm20M68wH6f6fpQHvSQ=";
      defaultJava = final.jdk21;
    }).wrapped;
}
// prev.lib.optionalAttrs (prev.stdenv.hostPlatform.system == "aarch64-darwin") {
  jdk21 = java21.overrideAttrs (
    finalAttrs: old: {
      # The stable nixpkgs installer expects a .jdk directory around Contents.
      postPatch = (old.postPatch or "") + ''
        if [ -d Contents ]; then
          mkdir -p zulu-21.jdk
          mv Contents zulu-21.jdk/
        fi
      '';
      passthru = old.passthru // {
        home = finalAttrs.finalPackage;
        bundle = "${finalAttrs.finalPackage}/Library/Java/JavaVirtualMachines/zulu-21.jdk";
      };
    }
  );
}
