if &compatible
  set nocompatible
endif

set runtimepath+=$HOME/.config/nvim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('/Users/dangvanthanh/.config/nvim/dein')
  call dein#begin('/Users/dangvanthanh/.config/nvim/dein')

  " Required:
  call dein#add('/Users/dangvanthanh/.config/nvim/dein/repos/github.com/Shougo/dein.vim')

  call dein#add('Shougo/deoplete.nvim')
  
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

set number

" Deoplete
let g:deoplete#enable_at_startup = 1
