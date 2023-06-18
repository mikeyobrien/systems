{
  description = "NixOS configs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
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

      (final: prev: {
        emacs-git = if final.stdenv.isDarwin then prev.emacs-git.overrideAttrs (old: {
          patches =
            (old.patches or [])
            ++ [
              # Fix OS window role (needed for window managers like yabai)
              (final.fetchpatch {
                url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
                sha256 = "+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
              })
              # Use poll instead of select to get file descriptors
              (final.fetchpatch {
                url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/poll.patch";
                sha256 = "jN9MlD8/ZrnLuP2/HUXXEVVd6A+aRZNYFdZF8ReJGfY=";
              })
              # Enable rounded window with no decoration
              (final.fetchpatch {
                url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/round-undecorated-frame.patch";
                sha256 = "qPenMhtRGtL9a0BvGnPF4G1+2AJ1Qylgn/lUM8J2CVI=";
              })
              # Make Emacs aware of OS-level light/dark mode
              (final.fetchpatch {
                url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/system-appearance.patch";
                sha256 = "oM6fXdXCWVcBnNrzXmF0ZMdp8j0pzkLE66WteeCutv8=";
              })
            ];
         }) else prev.emacs-git;
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
