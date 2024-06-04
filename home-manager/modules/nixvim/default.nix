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
      keymaps = {
        "<leader><space>" = {
	  action = "find_files";
	  options.desc = "Find project files";
	};
      };
    };
  };
}
