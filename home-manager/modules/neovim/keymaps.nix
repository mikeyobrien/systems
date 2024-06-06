{ ... }: {
  programs.nixvim = {
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
  };
}
