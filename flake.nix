{
  description = "NixOS configs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      # We want home-manager to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    flake-utils.url = "github:numtide/flake-utils";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };


  outputs = inputs@{ self, nixpkgs, home-manager, darwin, nixos-wsl, emacs-overlay, flake-utils, vscode-server, ... }:
  let
    mkConfig = import ./lib/mkConfig.nix;
    mkWsl = import ./lib/mkWsl.nix;
    mkDarwin = import ./lib/mkDarwin.nix;
    mkHomeConfig = import ./lib/mkHomeConfig.nix;
    overlays = [
      inputs.neovim-nightly-overlay.overlay
      inputs.emacs-overlay.overlay

      # https://discourse.nixos.org/t/error-when-upgrading-nixos-related-to-fcitx-engines/26940/12
      (final: prev: {
        fcitx-engines = final.fcitx5;
      })
    ];
  in {
    nixosConfigurations = {
      desktop = mkConfig "desktop" rec {
        inherit nixpkgs home-manager overlays vscode-server;
        system = "x86_64-linux";
        name = "desktop";
        user = "mobrienv";
     };

     wsl = mkWsl "wsl" rec {
        inherit nixpkgs nixos-wsl home-manager overlays vscode-server;
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
      devdesktop = mkHomeConfig "devdesktop" rec {
        inherit nixpkgs home-manager overlays;
        system = "x86_64-linux";
      };
    };
  };
}
