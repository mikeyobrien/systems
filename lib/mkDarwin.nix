# This function creates a nix-darwin system.
name: {
  darwin,
  nixpkgs,
  home-manager,
  system,
  user,
  overlays,
  agenix,
}:
darwin.lib.darwinSystem rec {
  inherit system;

  modules = [
    agenix.darwinModules.default
    # Apply our overlays. Overlays are keyed by system type so we have
    # to go through and apply our system type. We do this first so
    # the overlays are available globally.
    {nixpkgs.overlays = overlays;}
    ../machines/darwin.nix
    ../users/${user}/darwin.nix
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ../home-manager;
    }

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values.
    {
      config._module.args = {
        currentSystemName = name;
        currentSystem = system;
      };
    }
  ];
}
