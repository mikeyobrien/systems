## NixOS and Home-Manager configurations

Configurations for multiple machines.

### NixOS

``` 
nixos-rebuild switch --flake .#desktop
```

### nix-darwin (untested)

Switch,
``` 
nix build .#darwinConfigurations.<system>.system
./result/sw/bin/darwin-rebuild switch --flake .#<system>
```

### Home-Manager (untested)
Switch home-manager,
``` 
home-manager switch -b backup --flake .#<configuration>
```
