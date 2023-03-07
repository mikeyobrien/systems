{
  description = "NixOS configs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";

      # We want home-manager to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };


  outputs = inputs@{ self, nixpkgs, home-manager, darwin, ... }:
  let
    mkConfig = import ./lib/mkConfig.nix;
    mkDarwin = import ./lib/mkDarwin.nix;
    mkHomeConfig = import ./lib/mkHomeConfig.nix;
    overlays = [
      inputs.neovim-nightly-overlay.overlay
      inputs.emacs-overlay.overlay
    ];
  in {
    nixosConfigurations = {
      desktop = mkConfig "desktop" rec {
        inherit nixpkgs home-manager overlays;
        system = "x86_64-linux";
        name = "desktop";
        user = "mobrien";
     };
    };

    darwinConfigurations = {
      personal = mkDarwin "personal" rec {
        inherit nixpkgs home-manager overlays darwin;
        system = "aarch64-darwin";
        user = "mobrien";
      };

      work = mkDarwin "work" rec {
        inherit nixpkgs home-manager overlays darwin;
        system = "aarch64-darwin";
        user = "mobrienv";
      };
    };

    homeConfigurations = {
      x86_64-linux = mkHomeConfig "x86_64" rec {
        inherit nixpkgs home-manager overlays;
        system = "x86_64-linux";
      };
      aarch64-darwin = mkHomeConfig "aarch64-darwin" rec {
        inherit nixpkgs home-manager overlays;
        system = "aarch64-darwin";
      };
    };
  };
}
