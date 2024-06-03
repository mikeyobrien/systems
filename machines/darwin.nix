{ config, lib, pkgs, ... }:

{
  nix.useDaemon = true;

  age.secrets.some-secret = {
      file = ../secrets/some-secret.age;
      path = "/home/mobrienv/.some-secretrc";
  };

  nix.settings = {
    substituters = ["https://mikeyobrien.cachix.org"];
    trusted-public-keys = ["mikeyobrien.cachix.org-1:DzdUUa3CbbH03Fa1BoBKvixdnMr/dKRsTSyFyTP53Ws="];
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };


  services.nix-daemon.enable = true;

  programs.zsh.enable = true;
  programs.zsh.shellInit = ''
    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
    '';

  programs.fish.enable = true;
  programs.fish.shellInit = ''
    # Nix
    if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
      source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
    end
    # End Nix
    '';

  fonts.fontDir.enable = false;
  fonts.fonts = [
    (pkgs.nerdfonts.override { fonts = ["FiraCode" "JetBrainsMono"]; })
    pkgs.roboto
  ];

  environment.shells = with pkgs; [
    bashInteractive
    zsh
    fish
  ];

  homebrew = {
    enable = true;
    taps = [];
    casks = [
      "homebrew/cask/docker"
      "nikitabobko/tap/aerospace"
      "syncthing"
      "hammerspoon"
      "discord"
      "steam"
      "raycast"
      "imageoptim"
      "spotify"
      "jetbrains-toolbox"
      "ticktick"
      "obsidian"
    ];
  };

  environment.systemPackages = with pkgs; [
    cachix
  ];

}
