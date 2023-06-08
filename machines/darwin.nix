{ config, lib, pkgs, ... }:

{
  nix.useDaemon = true;
  nix.settings = {
    substituters = ["https://mikeyobrien.cachix.org"];
    trusted-public-keys = ["mikeyobrien.cachix.org-1:DzdUUa3CbbH03Fa1BoBKvixdnMr/dKRsTSyFyTP53Ws="];
  };

  services.nix-daemon.enable = true;

  programs.zsh.enable = true;
  programs.zsh.shellInit = ''
    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
    '';

  programs.fish.enable = true;
  programs.fish.shellInit = ''
    # Nix
    if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
      source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
    end
    # End Nix
    '';

  fonts.fontDir.enable = true;
  fonts.fonts = [
    (pkgs.nerdfonts.override { fonts = ["FiraCode" "JetBrainsMono"]; })
    pkgs.roboto
  ];

  environment.shells = with pkgs; [
    bashInteractive
    zsh
    fish
  ];

  services.yabai = {
    enable = true;
    extraConfig = builtins.readFile ./yabairc;
  };

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
# open iTerm2
cmd - return : /etc/profiles/per-user/mobrienv/bin/kitty

# Navigate
cmd - h : yabai -m window --focus west
cmd - j : yabai -m window --focus south
cmd - k : yabai -m window --focus north
cmd - l : yabai -m window --focus east

# swap managed window
shift + cmd - h : yabai -m window --warp west
shift + cmd - j : yabai -m window --warp south
shift + cmd - k : yabai -m window --warp north
shift + cmd - l : yabai -m window --warp east


# send window to desktop and follow focus
shift + cmd - m : yabai -m window --space  last; yabai -m space --focus last
shift + cmd - n : yabai -m window --space  next; yabai -m space --focus next
shift + cmd - p : yabai -m window --space  prev; yabai -m space --focus prev
shift + cmd - 1 : yabai -m window --space  1; yabai -m space --focus 1
shift + cmd - 2 : yabai -m window --space  2; yabai -m space --focus 2
shift + cmd - 3 : yabai -m window --space  3; yabai -m space --focus 3
shift + cmd - 4 : yabai -m window --space  4; yabai -m space --focus 4

# Resize windows
lctrl + cmd - h : yabai -m window --resize left:-50:0; \
                  yabai -m window --resize right:-50:0
lctrl + cmd - j : yabai -m window --resize bottom:0:50; \
                  yabai -m window --resize top:0:50
lctrl + cmd - k : yabai -m window --resize top:0:-50; \
                  yabai -m window --resize bottom:0:-50
lctrl + cmd - l : yabai -m window --resize right:50:0; \
                  yabai -m window --resize left:50:0

lctrl + cmd - e : yabai -m window --toggle

# float / unfloat window and center on screen
shift + cmd - t : yabai -m window --toggle float;\
          yabai -m window --grid 4:4:1:1:2:2

# Float / Unfloat window
shift + alt - space : \
    yabai -m window --toggle float; \
    yabai -m window --toggle border


# Set space to float
shift + cmd - p : yabai -m space --layout float

# Set space to bsp
shift + cmd - b : yabai -m space --layout bsp


# restart yabai
shift + cmd - space: \
    /usr/bin/env display <<< \
        "notification osascript \"Restarting Yabai\" with title \"Yabai\""; \
    pkill yabai


# Make window native fullscreen
# shift + cmd - f : yabai -m window --toggle native-fullscreen
'';
  };

  homebrew = {
    taps = [];
  };

  environment.systemPackages = with pkgs; [
    cachix
    tree-sitter
    gcc
    cmake
    bintools
    mu
  ];

}
