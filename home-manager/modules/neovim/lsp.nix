{pkgs, ...}: {
  programs.nixvim = {
    plugins.lazy.enable = true;
    plugins.lazy.plugins = [
      {
        pkg = pkgs.vimPlugins.vim-lspconfig;
        dependencies = with pkgs.vimPlugins; [
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          cmp-cmdline
          nvim-cmp
          luasnip
          cmp_luasnip
          fidget-nvim
        ];
        config = builtins.readFile ./lsp.lua;
      }
    ];
  };
}
