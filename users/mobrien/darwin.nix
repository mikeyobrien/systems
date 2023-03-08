{ config, lib, pkgs, ... }:

{
  homebrew = {
    enable = true;
    casks = [];
  };

  users.users.mobrienv = {
    home = "/Users/mobrien";
    shell = pkgs.fish;
  };
}
