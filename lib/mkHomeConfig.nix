user: { config, lib, pkgs, home-manager, user, system, overlays, ... }:

home-manager.lib.homeManagerConfiguration rec {
  inherit system;
  modules = [
    { nixpkgs.overlays = overlays; }
    ../home-manager
  ];
}
