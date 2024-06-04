user: {
    nixpkgs,
    overlays,
    inputs,
    system,
    user,
    name,
    ...
}:
nixpkgs.lib.nixosSystem rec {
  inherit system;
  modules = [
    { nixpkgs.overlays = overlays; }
    { imports = [ ../modules/nixos/sunshine.nix ]; }

    inputs.vscode-server.nixosModules.default
    ../hardware/${name}.nix
    ../machines/${name}.nix
    ../users/${user}/nixos.nix
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ../home-manager {
        inputs = inputs;
      };
    }

    {
      config._module.args = {
        currentSystemName = name;
        currentSystem = system;
        inputs = inputs;
      };
    }
  ];
}
