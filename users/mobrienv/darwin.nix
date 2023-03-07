{ config, lib, pkgs, ... }:

{
  homebrew = {
    enable = true;
    casks = [
      "1password"
      "alfred"
    ];
  };

  users.users.mobrienv = {
    home = "/Users/mobrienv";
    shell = pkgs.fish;
  };
}
