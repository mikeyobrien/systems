user: { nixpkgs, home-manager, system, overlays, ... }:

let 
  pkgs = import nixpkgs { inherit overlays system; config.allowUnfree = true; };

in
home-manager.lib.homeManagerConfiguration rec {
  inherit pkgs;
  modules = [
    {
      home.username = "mobrienv";
      home.homeDirectory = "/home/mobrienv/";
    }
    ../home-manager
  ];
}
