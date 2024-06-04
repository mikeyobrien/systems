{ pkgs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  users.users.mobrienv = {
    isNormalUser = true;
    home = "/home/mobrienv";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.fish;
    hashedPassword = "$6$h7nrbcXumdWOMzVA$x0CdnTLQbUi1mpekKER.mYmvSqUkx2ySI6UL7V1X3z70c.Hicjn4EkcHI3MkuCHpf080J9jnjnG2W9pgGa24j/";
    openssh.authorizedKeys.keys = [];
  };
}
