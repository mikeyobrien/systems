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
    offlineimap
    lua
    htop
    ripgrep
    fzf
    bat
    nix-direnv
    yadm
    grc
    tree-sitter
    nodejs

    # rust
    cargo
    rustc
    rust-analyzer
    git-crypt
    ((emacsPackagesFor emacsGit).emacsWithPackages (epkgs:
      with epkgs;
      [
        sqlite3
        pdf-tools
        org-pdftools
        vterm
        mu
      ]
    ))
  ] ++ (lib.optionals isLinux [
    _1password
    _1password-gui
    firefox
    rofi
    xclip
    xdotool
  ]) ++ (lib.optionals isDarwin [
    pinentry_mac
  ]);

  # TODO load user config if passed in, else default
  xdg.configFile."i3/config".text = builtins.readFile ./i3;

  programs.gpg.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
     font.size = 14;
    };
  };

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    #initExtra = builtins.readFile ./bashrc;

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
    };
  };


  programs.mu.enable = true;
  programs.fish = {
    enable = true;
    shellAliases = {
      python = "python3";
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
    };
    interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" [
      (builtins.readFile ./fish.config)
      "set -g SHELL ${pkgs.fish}/bin/fish"
    ]);
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "bass"; src = pkgs.fishPlugins.bass.src; }
      {
        name = "bobthefish";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "theme-bobthefish";
          rev = "76cac812064fa749ffc258a20398c6f6250860c5";
          sha256 = "1fssb5bqd2d7856gsylf93d28n3rw4rlqkhbg120j5ng27c7v7lq";
        };
      }
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
          sha256 = "+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
        };
      }
    ];
  };

  # bob the fish activation
  xdg.configFile."fish/conf.d/plugin-bobthefish.fish".text = lib.mkAfter ''
    set -g theme_newline_cursor yes
    set -g theme_newline_prompt '$ '
<<<<<<< HEAD
    set -g theme_display_date no
    set -g theme_powerline_fonts yes
=======
    fish_add_path $HOME/.config/emacs/bin
>>>>>>> b143266 (Go back to using emacsGit on macos)
    for f in $plugin_dir/*.fish
      source $f
    end
    '';

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
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
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
  };

  programs.i3status = {
    enable = isLinux;
  };

  services.gpg-agent = {
    enable = isLinux;
    pinentryFlavor = "tty";

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };


  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
