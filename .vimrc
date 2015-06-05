" Settings --------------------------------------------------

" Make Vim more useful
set nocompatible

" Syntax highlight
set t_Co=256
set background=dark
syntax on
colorscheme solarized
let g:solarized_termtrans=1

" Mapleader
let mapleader=","

" Centralize backups, swapsfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
  set undodir=~/.vim/undo
endif

" Copy indent from last line when starting new line
set autoindent
set smartindent
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Use UTF-8 without BOMB
set encoding=utf-8 nobomb
" Highlight current line
set cursorline
" By default add g to flag to search/replace. Add g to toggle
set gdefault
" When a buffer is brought to foreground, remember undo history and marks
set hidden
" Increase history from 20 default to 1000
set history=1000
" Highlight searches and incremental searching
set hlsearch
set incsearch
" Smart casing when search (ignore case unless an uppercase is found)
set ignorecase
set smartcase
" Always show status line
set laststatus=2
" Enable extended regex
set magic
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don't reset cursor to start of line when moving around
set nostartofline
" Show the current mode
set showmode
" Enable line numbers
set nu
set numberwidth=5
" Show the cursor position
set ruler
" Start scrolling three lines before horizontal border of window
set scrolloff=3
" Tab key results in 2 spaces
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
" Display tabs and trailing spaces visually
set list listchars=tab:»·,trail:·,nbsp:·
" Formatting options
set formatoptions=
set formatoptions+=c " Auto-wrap comments
set formatoptions+=r " Insert comment leader after <CR> in insert mode
set formatoptions+=q " Allow formatting of comments with gq
set formatoptions+=l " Long lines are not broken in insert mode
set formatoptions+=j " Remove comment leader when joining, if applies
" Status line
set statusline=
set statusline+=%1*\ [%2*%2n%1*]  " Buffer number
set statusline+=%<  " Truncate the path if needed
set statusline+=%3*\ %f  " File name
set statusline+=%4*%5r  " ReadOnly flag
set statusline+=%5*\ %y  " File type
set statusline+=%6*\ %m  " Modified flag

set statusline+=%=  " Separation

set statusline+=%1*\ [col\ %3*%v%1*]  " Virtual column number
set statusline+=%1*\ [row\ %2*%l%1*/%2*%L%1*\ %p%%]  " Current/total line
set statusline+=%1*\ [byte\ %5*%o%1*]  " Byte number in file

hi User1 ctermfg=255 guifg=#eeeeee ctermbg=235 guibg=#262626
hi User2 ctermfg=167 guifg=#d75757 ctermbg=235 guibg=#262626
hi User3 ctermfg=107 guifg=#87af5f ctermbg=235 guibg=#262626
hi User4 ctermfg=33 guifg=#0087ff ctermbg=235 guibg=#262626
hi User5 ctermfg=221 guifg=#ffd75f ctermbg=235 guibg=#262626
hi User6 ctermfg=133 guifg=#af5faf ctermbg=235 guibg=#262626

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" Configuration --------------------------------------------

" FastEscape
" Speed up transition from modes
if ! has('gui_running')
	set ttimeoutlen=10
	augroup FastEscape
		autocmd!
		au InsertEnter * set timeoutlen=0
		au InsertLeave * set timeoutlen=1000
	augroup END
endif

" General
augroup general_config
	autocmd!

	" Speed up viewport scrolling
	nnoremap <C-e> 3<C-e>
	nnoremap <C-y> 3<C-y>

	" Faster split reszing (+,-)
	if bufwinnr(1)
		map + <C-W>+
		map - <C-W>-
	endif

	" Better split switching (Ctrl-j, Ctrl-k, Ctrl-h, Ctrl-l)
	map <C-j> <C-W>j
	map <C-k> <C-W>k
	map <C-H> <C-W>h
	map <C-L> <C-W>l

	" Toggle show tabs and trailing spaces (,c)
	set lcs=tab:›\ ,trail:·,eol:¬,nbsp:_
	set fcs=fold:-
	nnoremap <silent> <leader>c :set nolist!<CR>

	" Clear last search (,qs)
	map <silent> <leader>gs <Esc>:noh<CR>

	" Remap keys for auto-completion menu
	inoremap <expr> <CR>   pumvisible() ? "\<C-y>" : "\<CR>"
	inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
	inoremap <expr> <Up>   pumvisible() ? "\<C-p>" : "\<Up>"

	" Paste toggle (,p)
	set pastetoggle=<leader>p
	map <leader>p :set invpaste paste?<CR>

	" Yank from cursor to end of line
	nnoremap Y y$

	" Insert newline
	map <leader><Enter> o<ESC>

	" Search and replace word under cursor (,*)
	nnoremap <leader>* :%s/\<<C-r><C-w>\>//<Left>
	vnoremap <leader>* "hy:%s/\V<C-r>h//<left>

	" Fix page up and down
	map <PageUp> <C-U>
	map <PageDown> <C-D>
	map <PageUp> <C-O><C-U>
	map <PageDown> <C-O><C-D>
augroup END

" Filetypes -------------------------------------------------

" Handlebars
augroup filetype_hbs
	autocmd!
	au BufRead,BufNewFile *.hbs,*.handlebars set ft=mustache syntax=mustache
augroup END

" Jade
augroup filetype_jade
	autocmd!
	au BufRead,BufNewFile *.jade set ft=jade syntax=jade
augroup END

" JavaScript
augroup filetype_javascript
	autocmd!
	let g:javascript_conceal = 1
augroup END

" JSON
augroup filetype_json
	autocmd!
	au BufRead,BufNewFile *.json set ft=json syntax=Javascript
augroup END

" Markdown
augroup filetype_markdown
	autocmd!
	let g:markdown_fenced_languages = ['html', 'javascript', 'css', 'bash=sh']
augroup END

" XML
augroup filetype_xml
	autocmd!
	au FileType xml exe ":silent 1, $!xmllint --format --recover - 2>/dev/null"
augroup END

" ZSH
augroup filetype_zsh
	autocmd!
	au BufRead,BufNewFile .zshrc,.functions set ft=zsh
augroup END

" Plugin Configuration --------------------------------------

" Airline.vim
augroup airline_config
	autocmd!
	let g:airline_powerline_fonts = 1
	let g:airline#extensions#tabline#buffer_nr_format = '%s '
	let g:airline#extensions#tabline#buffer_nr_show = 1
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#fnamecollapse = 0
	let g:airline#extensions#tabline#fnamemod = ':t'
augroup END

" CtrlP.vim
augroup ctrlp_config
	autocmd!
	let g:ctrlp_clear_cache_on_exit = 0 " Don't clear filenames cache, to improve CtrlP startup
	let g:ctrlp_lazy_update = 350 " Set delay to prevent extra search
	let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' } " Use Python fuzzy matcher for better performance
	let g:ctrlp_match_window_bottom = 0 " Show at top of window
	let g:ctrlp_max_files = 0 " Set no file limit, we are building a big project
	let g:ctrlp_switch_buffer = 'Et' " Jump to tab AND buffer if already open
	let g:ctrlp_open_new_file = 'r' " Open newly created files in the current window
	let g:ctrlp_open_multiple_files = 'ij' " Open multiple files in hidden buffers and jump to the first one
augroup END

" EasyAlign.vim
augroup easyalign_config
	autocmd!
	vmap <Enter> <Plug>(EasyAlign) " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
	nmap <Leader>a <Plug>(EasyAlign) " Start interactive EasyAlign for a motion/text obejct (e.g. <Leader>aip)
augroup END

" Syntastic.vim
augroup syntastic_config
	autocmd!
	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 1
	let g:syntastic_check_on_open = 1
	let g:syntastic_check_on_wq = 0
augroup END

" Ultisnips.vim
augroup ultisnips_config
	let g:UltiSnipsExpandTrigger='<tab>'
	let g:UltiSnipsJumpForwardTrigger='<c-b>'
	let g:UltiSnipsJumpBackwardTrigger='<c-z'
augroup END

" Plugins ---------------------------------------------------

" Load Plugins
call plug#begin('~/.vim/plugged')

Plug 'ap/vim-css-color'
Plug 'junegunn/vim-easy-align'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'pangloss/vim-javascript'
Plug 'mustache/vim-mustache-handlebars'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/jade.vim', { 'for': 'jade' }
Plug 'wavded/vim-stylus', { 'for': 'stylus' }
Plug 'mattn/emmet-vim'
Plug 'SirVer/ultisnips'
Plug 'editorconfig/editorconfig-vim'

call plug#end()
