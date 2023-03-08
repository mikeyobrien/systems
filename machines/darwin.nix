{ config, lib, pkgs, ... }:

{
  nix.useDaemon = true;
  nix.settings = {
    substituters = ["https://mikeyobrien.cachix.org"];
    trusted-public-keys = ["mikeyobrien.cachix.org-1:DzdUUa3CbbH03Fa1BoBKvixdnMr/dKRsTSyFyTP53Ws="];
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

  fonts.fontDir.enable = true;
  fonts.fonts = [
    (pkgs.nerdfonts.override { fonts = ["FiraCode" "JetBrainsMono"]; })
  ];

  environment.shells = with pkgs; [
    bashInteractive
    zsh
    fish
  ];

  environment.systemPackages = with pkgs; [
    cachix
  ];

}
