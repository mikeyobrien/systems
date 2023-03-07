{ config, lib, pkgs, ... }:

{
  homebrew = {
    enable = true;
    casks = [];
  };

  users.users.mobrienv = {
    home = "/Users/mobrienv";
    shell = pkgs.fish;
  };
}
