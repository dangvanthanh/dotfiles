set nocompatible 
set encoding=utf8
filetype off
      
" Plugins
call plug#begin('~/.vim/plugged')

" Themes
Plug 'dracula/vim'

" Languages
Plug 'othree/html5.vim'
Plug 'leshill/vim-json'
Plug 'elixir-lang/vim-elixir', { 'for': 'elixir' }
Plug 'slashmili/alchemist.vim', { 'for': 'elixir' }
Plug 'pangloss/vim-javascript'
Plug 'ap/vim-css-color'
Plug 'posva/vim-vue'

" Themes
Plug 'tpope/vim-surround'
Plug 'rking/ag.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'

call plug#end()

filetype indent plugin on

syntax on
color dracula

set laststatus=2
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

" Airline
let g:airline#extension#tabline#enabledi = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='simple'

map <F2> :NERDTreeToggle<CR>

nnoremap <C-b> :Buffers<CR>
nnoremap <C-g> :Ag<CR>
nnoremap <leader><leader> :Commands<CR>
nnoremap <C-p> :Files<CR>
