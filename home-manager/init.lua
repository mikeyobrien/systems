-- Set background color
vim.background = "dark"
vim.cmd([[colorscheme gruvbox]])

-- https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
local cmp = require'cmp'
cmp.setup {
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }, {
    { name = 'buffer' },
  }),
}

-- Global variables
vim.g.vim_home_path = "~/.config/nvim"
vim.g.startify_change_to_vcs_root = 0

-- Leader key
vim.g.mapleader = " "

-- Set options
vim.o.cmdheight = 2
vim.o.termguicolors = true
vim.o.mouse = 'a'
vim.o.autoread = true
vim.o.backspace = '2'
vim.o.hidden = true
vim.o.laststatus = 2
vim.o.list = true
vim.o.number = true
vim.o.ruler = true
-- vim.o.t_Co = "256"
vim.o.scrolloff = 999
vim.o.showmatch = true
vim.o.showmode = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.title = true
vim.o.visualbell = true
vim.cmd("syntax on")

-- Backup, swap, undo directories
-- Uncomment and edit paths if needed
-- vim.o.directory = vim.g.vim_home_path .. "/swap"
-- vim.o.backupdir = vim.g.vim_home_path .. "/backup"
-- vim.o.undodir = vim.g.vim_home_path .. "/undo"

-- Mappings
vim.api.nvim_set_keymap('i', 'jk', '<esc>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>y', '"*y', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>p', '"*p', {noremap = true})

-- Disable backup
vim.o.backup = false
vim.o.writebackup = false

-- Undofile
vim.o.undofile = true

-- Search settings
vim.o.updatetime = 300
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.smartcase = true

-- Indentation
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2

-- Wildmenu settings
vim.o.wildmode = 'list:longest'
vim.o.wildignore = vim.o.wildignore .. '.git,.gh,.svn,*.6,*.pyc,*.rbc,*.swp'

-- More mappings
vim.api.nvim_set_keymap('n', '<leader><tab><tab>', '<cmd>tabs<cr>', {noremap = true})
vim.api.nvim_set_keymap('i', 'jj', '<esc>', {noremap = true})
vim.api.nvim_set_keymap('n', 'j', 'gj', {noremap = true})
vim.api.nvim_set_keymap('n', 'k', 'gk', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>cd', ':cd %:h<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>lcd', ':lcd %:h<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>bp', ':bp<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>bn', ':bn<CR>', {noremap = true})

-- Split navigation
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {noremap = true})
-- MacOS specific fix
vim.api.nvim_set_keymap('n', '<BC>', '<C-W>h', {noremap = true})

-- Remember cursor position
vim.cmd([[
augroup vimrc_remember_cursor_position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
]])

-- Mason
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls", "jdtls", "tsserver", "pyright" },
}

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig').lua_ls.setup({
  capabilities =  lsp_capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim', 'hs'}
      }
    }
  }
})

-- Telescope setup
require("telescope").setup({
  defaults = {
    file_ignore_patterns = {"build", "env", "test-runtime", "bin"},
  }
})

vim.api.nvim_set_keymap('n', '<leader><leader>', "<cmd>lua require('telescope.builtin').git_files()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ca', "<cmd>lua vim.lsp.buf.code_action()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ld', "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>lr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>li', "<cmd>lua require('telescope.builtin').lsp_incoming_calls()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>lo', "<cmd>lua require('telescope.builtin').lsp_outgoing_calls()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>pF', "<cmd>lua require('telescope').extensions.project.project{}<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>p', "<cmd>lua require('telescope.builtin').commands()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>bb', "<cmd>lua require('telescope.builtin').buffers()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').file_browser()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>sp', "<cmd>lua require('telescope.builtin').live_grep()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ss', "<cmd>lua require('telescope.builtin').grep_string()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>bb', "<cmd>lua require('telescope.builtin').buffers()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gb', "<cmd>lua require('telescope.builtin').git_branches()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gc', "<cmd>lua require('telescope.builtin').git_commits()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gC', "<cmd>lua require('telescope.builtin').git_bcommits()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gs', "<cmd>lua require('telescope.builtin').git_status()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gS', "<cmd>lua require('telescope.builtin').git_stash()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>t', "<cmd>lua require('telescope.builtin').treesitter()<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>!', "<cmd>lua require('telescope.builtin').command_history()<cr>", {noremap = true, silent = true})

-- nvim web devicons
require'nvim-web-devicons'.setup{ default = true; }

-- hop-nvim
require'hop'.setup()
vim.api.nvim_set_keymap('n', 's', '<cmd>HopChar2<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>j', '<cmd>HopLine<cr>', {noremap = true})


-- Load work init file if found
local work_init = vim.fn.expand("~/.config/nvim/work_init.lua")
local f = io.open(work_init, "r")
if f ~= nil then
    io.close(f)
    vim.cmd("source " .. work_init)
end


