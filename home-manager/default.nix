{ config, pkgs, lib, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.packages = with pkgs; [
    (pkgs.nerdfonts.override { fonts = ["FiraCode" "JetBrainsMono"]; })
    jq
    fd
    ripgrep
    babashka
    mu
    offlineimap
    lua
    htop
    ripgrep
    fzf
    bat
    nix-direnv
    yadm
    grc

    # rust
    cargo
    rustc
    rust-analyzer

    git-crypt

  ] ++ (lib.optionals isLinux [
    ((emacsPackagesFor emacsUnstable).emacsWithPackages (epkgs:
      with epkgs;
      # Use Nix to manage packages with non-trivial userspace dependencies.
      [
        sqlite3
        pdf-tools
        org-pdftools
        vterm
      ]
    ))
    _1password
    _1password-gui
    firefox
    rofi
  ]) ++ (lib.optionals isDarwin [
  ]);

  # TODO load user config if passed in, else default
  xdg.configFile."i3/config".text = builtins.readFile ./i3;

  programs.alacritty = {
    enable = true;
    settings = {
     font.size = 14;
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      update-desktop = "sudo nixos-rebuild switch --flake /home/mobrien/Code/nix#desktop";
    };
    interactiveShellInit = ''
      fish_add_path $HOME/.emacs.d/bin/

      # if file extraInit file exists, source it.
      if test -e $HOME/.config/fish/extra.config
          source $HOME/.config/fish/extra.config
      end
    '';
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "hydro"; src = pkgs.fishPlugins.hydro.src; }
      { name = "bass"; src = pkgs.fishPlugins.bass.src; }
    ];
  };

  programs.zsh = {
    enable = false;
    shellAliases = {
      update-desktop = "sudo nixos-rebuild switch --flake /home/mobrien/Code/nix#desktop";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "zsh-users/zsh-history-substring-search"; }
        { name = "zsh-users/zsh-completions"; }
      ];
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    initExtra = ''
      # Emacs tramp fix
      if [[ "$TERM" == "dumb" ]]
      then
        unsetopt zle
        unsetopt prompt_cr
        unsetopt prompt_subst
        unfunction precmd
        unfunction preexec
        PS1='$ '
      fi
    '';
  };

  programs.starship = {
    enable = false;
    enableFishIntegration = true;
    settings = {
      git_status = {
        disabled = true;
      };
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    escapeTime = 0;
    prefix = "C-a";
    keyMode = "vi";
    baseIndex = 1;
    aggressiveResize = true;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.yank;
        extraConfig = '' 
          set -g @yank_selection 'primary'
          bind-key -T copy-mode-vi 'v' send -X begin-selection
          bind-key -T copy-mode-vi 'r' send -X rectangle-toggle
          bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel
          bind Enter copy-mode
        '';
      }
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.power-theme
    ];
    extraConfig = builtins.readFile ./tmux.conf;
  };

  programs.git = {
    enable = true;
    userName = "mikeyobrien";
    userEmail = "hmobrienv@gmail.com";
    extraConfig = {
      safe.directory = [ "*" ];
    };
  };

  programs.neovim = {
    enable = true;
    withPython3 = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
      vim-commentary
      vim-eunuch
      vim-fireplace
      vim-fugitive
      vim-markdown
      vim-nix
      vim-startify
      vim-terraform
      vim-tmux-navigator

      nvim-jdtls
      nvim-dap

      nvim-web-devicons
      nvim-colorizer-lua
      nvim-treesitter
      plenary-nvim
      telescope-nvim
      telescope-coc-nvim
      telescope-project-nvim
      hop-nvim

      # colorscheme
      lush-nvim
      gruvbox-nvim
    ];
    extraConfig = builtins.readFile ./init.vim;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.i3status = {
    enable = isLinux;
  };

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
