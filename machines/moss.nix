# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  ...
}: let
  lgtv = pkgs.callPackage ../pkgs/lgwebosremote/lgwebosremote.nix {};
in {
  nix.settings.trusted-users = ["root" "mobrienv"];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = ["amdgpu"];

  networking = {
    hostName = "moss";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
  };

  services.printing.enable = true;
  hardware.pulseaudio.enable = false;
  security.sudo.wheelNeedsPassword = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.nix-ld.enable = true;
  programs.fish = {
    enable = true;
  };
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    inputs.alejandra.defaultPackage.${system}
    nix-prefetch-scripts
    nixpkgs-fmt
    lgtv
    gcc
    zig
    vim
    wget
    gnome.gnome-tweaks
    gnome.adwaita-icon-theme
  ];

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
      gedit
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

  systemd.services.lgtvScreenOff = {
    enable = true;
    description = "Turn lgtv screen off suspend";
    before = ["suspend.target"];
    serviceConfig = {
      ExecStart = "${lgtv}/bin/lgtv --ssl screenOff";
      User = "mobrienv";
    };
  };

  systemd.services.lgtvScreenOn = {
    enable = true;
    description = "Turn lgtv screen on on wake";
    after = ["suspend.target"];
    serviceConfig = {
      ExecStart = "${lgtv}/bin/lgtv --ssl screenOn";
      User = "mobrienv";
    };
  };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  networking.firewall.enable = false;

  system.stateVersion = "24.05"; # Did you read the comment?
}
