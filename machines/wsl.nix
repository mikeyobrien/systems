{ lib, pkgs, config, modulesPath, user, defaultUser, ... }:

{
  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "${defaultUser}";
    startMenuLaunchers = true;

    # Enable native Docker support
    docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = true;
  };

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    gnumake
    cmake
    vim
    gcc
    libtool
    emacsPgtk
    wayland
    firefox

    # rust
    cargo
    rustc
  ];

  security.polkit.enable = true;
  system.stateVersion = "22.11";
}

