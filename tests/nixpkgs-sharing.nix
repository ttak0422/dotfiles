# Evaluate without building a host system:
# nix eval --impure --json --file tests/nixpkgs-sharing.nix
let
  flake = builtins.getFlake (toString ../.);
  inherit (flake) inputs;
  check = system:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ (import ../nix/overlays/custom-packages.nix { inherit inputs; }) ];
      };
      isDarwin = system == "aarch64-darwin";
      package = if isDarwin then pkgs.brewCasks.neovide-app else pkgs.rose-pine-hyprcursor;
      upstream =
        if isDarwin then
          inputs.brew-nix.packages.${system}.neovide-app
        else
          inputs.rose-pine-hyprcursor.packages.${system}.default;
      expectedStdenv = if isDarwin then pkgs.stdenvNoCC else pkgs.stdenv;
    in
    assert package.stdenv.drvPath == expectedStdenv.drvPath;
    assert package.src.outPath == upstream.src.outPath;
    assert package.version == upstream.version;
    assert !isDarwin || builtins.elem pkgs._7zz.drvPath (map (p: p.drvPath) package.nativeBuildInputs);
    {
      inherit system;
      package = package.drvPath;
      hostStdenv = expectedStdenv.drvPath;
    };
in
map check [ "aarch64-darwin" "x86_64-linux" "aarch64-linux" ]
