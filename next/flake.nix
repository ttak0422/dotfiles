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
  };
  outputs = inputs: {
    darwinConfigurations.macbook = import ./lib/mk-darwin.nix { inherit inputs; } {
      username = builtins.getEnv "DOTFILES_USERNAME";
      homeDirectory = builtins.getEnv "DOTFILES_HOME";
    };
  };
}
