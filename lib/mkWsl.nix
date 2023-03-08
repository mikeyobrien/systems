user: { nixpkgs, home-manager, system, overlays, user, name, nixos-wsl, ... }:

nixpkgs.lib.nixosSystem rec {
  inherit system;
  modules = [
    { nixpkgs.overlays = overlays; }
    ../machines/${name}.nix
    ../users/${user}/nixos.nix

    nixos-wsl.nixosModules.wsl
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ../home-manager;
    }
 
    {
      config._module.args = {
        defaultUser = user;
        currentSystem = system;
      };
    }
  ];
}
