{ config, pkgs, lib, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [
    ../modules/protonmail-bridge.nix
  ];

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
  home.file.".aerospace.toml" = {
      text = builtins.readFile ./aerospace.toml;
  };

  home.packages = with pkgs; [
    (pkgs.nerdfonts.override { fonts = ["FiraCode" "JetBrainsMono"]; })
    jq
    fd
    ripgrep
    cachix
    babashka
    lua
    expect
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
    glow

    # rust
    cargo
    rustc
    rust-analyzer
    git-crypt
    python3
    nodePackages.pyright

  ] ++ (lib.optionals isLinux [
    xclip
    xdotool
  ]) ++ (lib.optionals isDarwin [
    pinentry_mac
  ]);

  # TODO load user config if passed in, else default
  xdg.configFile."i3/config".text = builtins.readFile ./i3;

  programs.gpg.enable = true;

  programs.starship.enable = true;
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font.size = 14;
      font.normal.family = "JetBrainsMono Nerd Font";
      key_bindings = [
        { key = "K"; mods = "Command"; chars = "ClearHistory"; }
        { key = "V"; mods = "Command"; action = "Paste"; }
        { key = "C"; mods = "Command"; action = "Copy"; }
        { key = "Key0"; mods = "Command"; action = "ResetFontSize"; }
        { key = "Equals"; mods = "Command"; action = "IncreaseFontSize"; }
        { key = "Minus"; mods = "Command"; action = "DecreaseFontSize"; }
      ];
    };
  };


  programs.bash = {
    enable = false;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    #initExtra = builtins.readFile ./bashrc;

    shellAliases = {
      bbka = lib.getExe pkgs.babashka;
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

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      bbka = lib.getExe pkgs.babashka;
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
    #extraLuaConfig = builtins.readFile ../dotfiles/nvim/init.lua;
  };

  programs.direnv = {
    enable = true;
  };

  programs.i3status = {
    #enable = isLinux;
  };

  services.gpg-agent = {
    enable = isLinux;
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
  services.protonmail-bridge.enable = isLinux;

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
