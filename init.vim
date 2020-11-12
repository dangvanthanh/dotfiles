language en_US

" Easy split navigation
nnoremap <C-w> <C-w>w
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

set nocompatible 
set encoding=UTF-8
filetype plugin indent on

syntax on
set termguicolors
colorscheme gruvbox
set background=dark
set guifont=Iosevka\ Slab:h16
set laststatus=2

set clipboard^=unnamed,unnamedplus
set t_RV=
set t_Co=256
set number
set showmatch
set visualbell

set hlsearch
set smartcase
set ignorecase
set incsearch

set autoindent
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=2

set ruler
set undolevels=1000
set backspace=indent,eol,start

set nobackup
set nowritebackup
set noswapfile
set noundofile

set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

" Plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'morhetz/gruvbox'

" Frontend
Plug 'othree/html5.vim'
Plug 'elzr/vim-json'
Plug 'JulesWang/css.vim'
Plug 'ap/vim-css-color'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'pangloss/vim-javascript'
Plug 'posva/vim-vue'

" Elm
Plug 'elmcast/elm-vim'

" Elixir
Plug 'elixir-lang/vim-elixir', { 'for': 'elixir' }
Plug 'slashmili/alchemist.vim', { 'for': 'elixir' }

" Svelte
Plug 'evanleck/vim-svelte'

" Themes
Plug 'itchyny/lightline.vim'

" Miscellaneous
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'w0rp/ale'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'
Plug 'sbdchd/neoformat'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" Python
let g:python_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

" Nerdtree
let g:NERDTreeIgnore = ['.DS_Store', '.cache$', 'node_modules$', '.git$', 'debug$', '\~$']
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeStatusline = ''
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <F2> :NERDTreeToggle<CR>

" Elm
"let g:polyglot_disabled = ['elm']
let g:elm_setup_keybindings = 0
let g:elm_detailed_complete = 1
let g:elm_format_autosave = 1

" Vue
let g:vue_disable_pre_processors = 1

" Prettier
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql PrettierAsync
let g:prettier#autoformat = 1
let g:prettier#exec_cmd_async = 1
let g:prettier#config#parser = 'babylon'

" Ale
let g:ale_fixers = {
\  'elixir': ['mix_format'],
\  'javascript': ['prettier'],
\  'typescript': ['prettier'],
\  'vue': ['prettier'],
\  'scss': ['prettier'],
\  'html': ['prettier'],
\  'svelte': ['prettier']
\}
let g:ale_fix_on_save = 1
let g:ale_completion_autoimport = 1

" Fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!{node_modules/*,debug/*,.git/*}"'
nnoremap <C-b> :Buffers<CR>
nnoremap <leader><leader> :Commands<CR>
nnoremap <C-p> :Files<CR>

" Emmet
autocmd FileType html,css EmmetInstall
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key=','

" Commentary
autocmd FileType apache setlocal commentstring=#\ %s
