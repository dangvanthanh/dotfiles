language en_US

" Easy split navigation
nnoremap <C-w> <C-w>w
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

set nocompatible 
set encoding=utf8
filetype plugin indent on

syntax on
set termguicolors
colorscheme gruvbox
highlight link cssPositioningProp GruvboxAqua
highlight link cssBorderProp GruvboxAqua
set background=dark
set guifont=Fira\ Code:h16
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

" Plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'dracula/vim', { 'as': 'dracula' }
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
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'sbdchd/neoformat'

call plug#end()

" Nerdtree
let NERDTreeIgnore = ['.DS_Store', 'node_modules$', '.git$', '\~$']
let NERDTreeShowHidden = 1
map <F2> :NERDTreeToggle<CR>

" Elm
let g:polyglot_disabled = ['elm']
let g:elm_setup_keybindings = 0
let g:elm_detailed_complete = 1
let g:elm_format_autosave = 1

" Vue
let g:vue_disable_pre_processors = 1

" Prettier
autocmd BufWritePre *.jsx,*.js,*.ts,*.json,*.css,*.scss,*.less,*.graphql,*.md Prettier
let g:prettier#autoformat = 0
let g:prettier#config#single_quote = 'true'

" Neoformat
autocmd FileType javascript setlocal formatprg=prettier\ --stdin\ --parser\ flow\ --single-quote\ --trailing-comma\ es5
let g:neoformat_try_formatprg = 1

" Ale
let g:ale_fixers = {}
let g:ale_fixers['elixir'] = ['mix_format']
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_linters = {'javascript': ['']}
let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5'

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#num_processes = 1

" Fzf
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
nnoremap <C-b> :Buffers<CR>
nnoremap <C-g> :Ag<CR>
nnoremap <leader><leader> :Commands<CR>
nnoremap <C-p> :Files<CR>

" Emmet
autocmd FileType html,css EmmetInstall
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key=','

" Commentary
autocmd FileType apache setlocal commentstring=#\ %s
