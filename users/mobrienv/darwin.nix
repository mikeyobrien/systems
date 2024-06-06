{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.mobrienv = {
    home = "/Users/mobrienv";
    shell = pkgs.fish;
  };
}
