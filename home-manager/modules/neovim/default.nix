{
  inputs,
  pkgs,
  ...
}: {
  imports = [ 
    ./keymaps.nix 
    ./telescope.nix 
  ];
  home.shellAliases.v = "nvim";
  programs.nixvim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

    defaultEditor = true;
    luaLoader.enable = true;

    viAlias = true;
    vimAlias = true;
    globals.mapleader = " ";

    extraPackages = with pkgs; [
      tree-sitter
    ];
   
    opts = {
      number = true;
      relativenumber = true;
      signcolumn = "yes";
      ignorecase = true;
      smartcase = true;
      undofile = true;
      undodir.__raw = "vim.fn.expand(\"~/.config/nvim/undodir\")";

      # Tab defaults (might get overwritten by an LSP server)
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      smarttab = true;

      clipboard = "unnamedplus";
      ruler = true;
      scrolloff = 5;
    };

    colorschemes.tokyonight.enable = true;
    colorschemes.tokyonight.settings.integrations.treesitter = true;
    plugins.lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
        lua-ls.enable = true;
      };
    };
  };
}
