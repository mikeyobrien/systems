{inputs, pkgs, ...}: {
  imports = [];

  home.shellAliases.v = "nvim";

  programs.nixvim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;

    colorschemes.tokyonight.enable = true;
    globals.mapleader = " ";
    plugins.telescope = {
      enable = true;
      extensions = {
        fzf-native = {
	  enable = true;
	};
	undo = {
	  enable = true;
	};
      };
      settings = {
        # Using this instead of the keymaps option, since the viml api has limitations
        mappings = {
	  a = { 
	    "<leader>_".__raw = ''require("telescope.builtin").find_files({})'';
	    "<leader>/".__raw = ''require("telescope.builtin").live_grep({})'';
	    "<leader>fr".__raw = ''require("telescope.builtin").oldfiles({})'';
	    "<leader>bu".__raw = ''Telescope undo'';
	    "<leader>ps".__raw = ''require("telescope.builtin").grep_string({ search = vim.fn.input("Grep >")})'';
	    "<leader>pWs".__raw = ''require("telescope.builtin").grep_string({ search = vim.fn.expand("<cWORD>")})'';
	    "<leader>vh".__raw = ''require("telescope.builtin").help_tags({})'';
	  };
	};
      };
    };
  };
}
