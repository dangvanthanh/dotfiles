set nocompatible    
filetype off        

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'bling/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'dracula/vim'
Plug 'ap/vim-css-color'
Plug 'tpope/vim-fugitive'

call plug#end()

filetype indent plugin on

syntax on
color dracula

set number
