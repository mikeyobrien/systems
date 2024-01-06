{ config, pkgs, lib, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [ ../modules/protonmail-bridge.nix ];
  xdg.enable = true;
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
  };


  xdg.configFile."polybar/launch.sh".text = builtins.readFile ./launch-polybar.sh;
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./rofi;

  home.packages = with pkgs; [
    (pkgs.nerdfonts.override { fonts = ["FiraCode" "JetBrainsMono"]; })
    jq
    fd
    ripgrep
    # babashka
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
    xsv
    nodejs
    pass
    ispell
    tree
    lazygit


    # rust
    cargo
    rustc
    rust-analyzer
    git-crypt
    #python
    nodePackages.pyright

  ] ++ (lib.optionals isLinux [
    ((emacsPackagesFor emacs-git).emacsWithPackages (epkgs:
      with epkgs;
      [
        sqlite3
        pdf-tools
        org-roam
        org-roam-ui
        org-pdftools
        vterm
        magit
        magit-section
        mu
        lsp-pyright
      ]
    ))
    _1password
    _1password-gui

    firefox
    rofi
    haskellPackages.greenclip

    discord

    # Emacs Everywhere
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

  programs.starship.enable = true;


  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty;
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
      gd = "git diff";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
      ntfycmd = "curl -d \"success\" https://ntfy.mikeyobrien.com/testing || curl -d \"failure\" https://ntfy.mikeyobrien.com/testing";
      #emacs = "${pkgs.emacs-git}/Applications/Emacs.app/Contents/MacOS/Emacs";
    };
    interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" [
      (builtins.readFile ./fish.config)
      "set -g SHELL ${pkgs.fish}/bin/fish"
      "set -gx PATH $PATH $HOME/bin"
    ]);
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "bass"; src = pkgs.fishPlugins.bass.src; }
      # {
      #   name = "bobthefish";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "oh-my-fish";
      #     repo = "theme-bobthefish";
      #     rev = "76cac812064fa749ffc258a20398c6f6250860c5";
      #     sha256 = "1fssb5bqd2d7856gsylf93d28n3rw4rlqkhbg120j5ng27c7v7lq";
      #   };
      # }
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
    set -g theme_display_date no
    set -g theme_powerline_fonts yes
    fish_add_path $HOME/.config/emacs/bin
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

  #home.file."Developer/lombok.jar" = {
  #  target = "${pkgs.lombok}/share/java/lombok.jar";
  #  type = "symlink";
  #};

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

      mason-nvim
      mason-lspconfig-nvim
      nvim-dap
      nvim-cmp
      vim-vsnip
      cmp-vsnip
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      nvim-jdtls
      nvim-lspconfig
      nvim-web-devicons
      nvim-colorizer-lua
      nvim-treesitter.withAllGrammars
      plenary-nvim
      telescope-nvim
      telescope-project-nvim
      hop-nvim

      # colorscheme
      lush-nvim
      gruvbox-nvim
    ];
    extraLuaConfig = builtins.readFile ./init.lua;
  };

  programs.direnv = {
    enable = true;
  };

  programs.i3status = {
    enable = isLinux;
  };

  services.gpg-agent = {
    # enable = isLinux;
    pinentryFlavor = "tty";

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  services.polybar = {
    enable = isLinux;
    package = pkgs.polybar.override {
      i3Support = true;
      alsaSupport = true;
      iwSupport = true;
      githubSupport = true;
    };
    config = ./polybar.ini;
    script = "polybar example &";
  };
  services.protonmail-bridge.enable = true;

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
