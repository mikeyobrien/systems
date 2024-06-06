{
  lib,
  pkgs,
  config,
  modulesPath,
  user,
  defaultUser,
  ...
}: {
  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "${defaultUser}";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
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
    wayland
    firefox

    ((emacsPackagesFor emacsPgtk).emacsWithPackages (
      epkgs:
        with epkgs; [
          sqlite3
          pdf-tools
          org-pdftools
          vterm
        ]
    ))

    # rust
    cargo
    rustc
  ];

  programs.fish.enable = true;
  services.vscode-server.enable = true;
  services.syncthing = {
    enable = true;
    dataDir = "/home/mobrienv";
    configDir = "/home/mobrienv/.config/syncthing";
    openDefaultPorts = true;
    user = "mobrienv";
    group = "users";
  };

  security.polkit.enable = true;
  system.stateVersion = "22.11";
}
