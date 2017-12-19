set nocompatible 
set encoding=utf8
filetype off
      
" Plugins
call plug#begin('~/.vim/plugged')

" Themes
Plug 'dracula/vim'

" Frontend
Plug 'othree/html5.vim'
Plug 'elzr/vim-json'
Plug 'ap/vim-css-color'
Plug 'prettier/vim-prettier'
Plug 'pangloss/vim-javascript'
Plug 'posva/vim-vue'

" Elixir
Plug 'elixir-lang/vim-elixir', { 'for': 'elixir' }
Plug 'slashmili/alchemist.vim', { 'for': 'elixir' }


" Themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Miscellaneous
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'vim-syntastic/syntastic'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'rking/ag.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'sheerun/vim-polyglot'

call plug#end()

filetype indent plugin on

syntax on
color dracula

set guifont=Fira\ Code:h16
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

" Prettier
let g:prettier#autoformat = 0
autocmd BufWritePre *.jsx,*.js,*.json,*.css,*.scss,*.less,*.graphql Prettier

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='simple'

" NERDTree
map <F2> :NERDTreeToggle<CR>

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Fzf
nnoremap <C-b> :Buffers<CR>
nnoremap <C-g> :Ag<CR>
nnoremap <leader><leader> :Commands<CR>
nnoremap <C-p> :Files<CR>
