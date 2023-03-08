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
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };


  outputs = inputs@{ self, nixpkgs, home-manager, darwin, nixos-wsl, ... }:
  let
    mkConfig = import ./lib/mkConfig.nix;
    mkWsl = import ./lib/mkWsl.nix;
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
     wsl = mkWsl "wsl" rec {
        inherit nixpkgs nixos-wsl home-manager overlays;
        system = "x86_64-linux";
        name = "wsl";
        user = "mobrienv";
     };
    };

    darwinConfigurations = {
      m1 = mkDarwin "m1" rec {
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
    };
  };
}
