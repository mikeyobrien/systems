set background=dark
colorscheme gruvbox

let g:vim_home_path = "~/.config/nvim"
let g:terraform_fmt_on_save = 1
let g:startify_change_to_vcs_root = 0

let mapleader=" "
set cmdheight=2
set termguicolors
set mouse=a
set autoread
set backspace=2
set hidden
set laststatus=2
set list
set number
set ruler
set t_Co=256
set scrolloff=999
set showmatch
set showmode
set splitbelow
set splitright
set title
set visualbell
syntax on

"execute "set directory=" . g:vim_home_path . "/swap"
"execute "set backupdir=" . g:vim_home_path . "/backup"
"execute "set undodir="   . g:vim_home_path . "/undo"

inoremap jk <esc>

" Shortcut to yanking to the system clipboard
map <leader>y "*y
map <leader>p "*p

" using coc.nvim some servers have issues with backup files, see #649
set nobackup
set nowritebackup

set undofile

set updatetime=300
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:check_back_space() abort
let col = col('.') - 1
return !col || getline('.')[col - 1]  =~# '\s'
endfunction

set hlsearch
set ignorecase
set incsearch
set smartcase

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth

set wildmode=list:longest
set wildignore+=.git,.gh,.svn
set wildignore+=*.6
set wildignore+=*.pyc
set wildignore+=*.rbc
set wildignore+=*.swp

inoremap jj <esc>
map j gj
map k gk

nmap <leader>cd :cd %:h<CR>
nmap <leader>lcd :lcd %:h<CR>
nmap <leader>bp :bp<CR>
nmap <leader>bn :bn<CR>


" Easier split navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" macos bugfix, C-h sent as backspace
nnoremap <BC> <C-W>h

" Remember cursor position
augroup vimrc-remember-cursor-position
autocmd!
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$"  ) | exe "normal! g`\"" | endif
augroup END

command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')


" Telescope
" lua require'telescope'.extensions.project.project{}
nnoremap <silent><leader>pF <cmd>lua require('telescope').extensions.project.project{}<cr>

nnoremap <leader><leader> <cmd>Telescope git_files<cr>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').file_browser()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

nnoremap <leader>sp <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>ss <cmd>lua require('telescope.builtin').grep_string()<cr>

nnoremap <leader>bb <cmd>lua require('telescope.builtin').buffers()<cr>

nnoremap <leader>gb <cmd>lua require('telescope.builtin').git_branches()<cr>
nnoremap <leader>gc <cmd>lua require('telescope.builtin').git_commits()<cr>
nnoremap <leader>gC <cmd>lua require('telescope.builtin').git_bcommits()<cr>
nnoremap <leader>gs <cmd>lua require('telescope.builtin').git_status()<cr>
nnoremap <leader>gS <cmd>lua require('telescope.builtin').git_stash()<cr>

nnoremap <leader>t  <cmd>lua require('telescope.builtin').treesitter()<cr>
nnoremap <leader>!  <cmd>lua require('telescope.builtin').command_history()<cr>

" nvim colorizer
lua require'colorizer'.setup()

"nvim web devicons
lua require'nvim-web-devicons'.setup{ default = true; };

"treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier",
    },
    additional_vim_regex_highlighting = false,
  },
}
EOF

" hop-nvim
lua require'hop'.setup()
nmap s <cmd>HopChar2<cr>
nmap <leader>j <cmd>HopLine<cr>

" tabs
nnoremap <leader><tab><tab> <cmd>tabs<cr>
