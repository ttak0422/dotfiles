{
  description = "Next-generation workstation configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";
    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles-nvim.url = "github:ttak0422/dotfiles-nvim";
    neru = {
      url = "github:y3owk1n/neru";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    slk.url = "github:gammons/slk/v0.53.0";
    yaskkserv2 = {
      url = "github:wachikun/yaskkserv2/08aabbc91a39c67ff2562b29f92c2a274bd0394b";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: {
    packages.aarch64-darwin.azoo-key-skkserv =
      inputs.nixpkgs.legacyPackages.aarch64-darwin.callPackage ./packages/azoo-key-skkserv.nix { };

    darwinConfigurations.macbook = import ./lib/mk-darwin.nix { inherit inputs; } {
      username = builtins.getEnv "DOTFILES_USERNAME";
      homeDirectory = builtins.getEnv "DOTFILES_HOME";
    };
  };
}
