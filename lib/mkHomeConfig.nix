user: { nixpkgs, home-manager, system, user, overlays, vscode-server, ... }:

let 
  pkgs = import nixpkgs { inherit overlays system; config.allowUnfree = true; };
in
home-manager.lib.homeManagerConfiguration rec {
  inherit pkgs;
  modules = [
    vscode-server.homeModules.default
    {
      imports = [ 
        ../modules/protonmail-bridge.nix 
      ];

      home.username = "${user}";
      home.homeDirectory = "/home/${user}/";
      # Why doesn't this work in the home file
      services.vscode-server.enable = true;
    }
    ../home-manager
  ];
}
