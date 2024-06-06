{
  inputs,
  pkgs,
  ...
}: {
  imports = [];
  home.shellAliases.v = "nvim";
  programs.nixvim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

    defaultEditor = true;
    luaLoader.enable = true;

    viAlias = true;
    vimAlias = true;
    globals.mapleader = " ";

    keymaps = [
      {
        key = "<C-d>";
        action = "<C-d>zz";
      }
      {
        key = "<C-u>";
        action = "<C-u>zz";
      }
      {
        key = "<leader>f";
        action = "<cmd>lua vim.lsp.buf.format()<CR>";
      }
      {
        mode = "n";
        key = "<leader>g";
        action = "<cmd>help<CR>";
      }
      {
        mode = "n";
        key = "<leader>pv";
        action = "<cmd>lua vim.cmd.Ex()<CR>";
      }
    ];

    opts = {
      number = true;
      relativenumber = true;
      signcolumn = "yes";
      ignorecase = true;
      smartcase = true;

      # Tab defaults (might get overwritten by an LSP server)
      tabstop = 4;
      shiftwidth = 4;
      softtabstop = 4;
      expandtab = true;
      smarttab = true;

      clipboard = "unnamedplus";
      ruler = true;
      scrolloff = 5;
    };

    colorschemes.tokyonight.enable = true;
    plugins.lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
        lua-ls.enable = true;
      };
    };

    colorschemes.tokyonight.settings.integrations.treesitter = true;
    plugins.treesitter = {
      enable = true;
    };
    plugins.treesitter-textobjects = {
      enable = true;
    };

    colorschemes.tokyonight.settings.integrations.native_lsp.enabled = true;
    plugins.telescope = {
      enable = true;
      extensions = {
        fzf-native = {
          enable = true;
        };
      };
    };
  };
}
