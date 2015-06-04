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

" Set other
set autoindent " Copy indent from last line when starting new line
set esckeys " Allow cursor keys in insert mode
set backspace=indent,eol,start " Allow backspace in insert mode
set cursorline " Highlight current line
set encoding=utf-8 nobomb " Use UTF-8 without BOMB
set expandtab " Expand tabs to spaces
set gdefault " By default add g to flag to search/replace. Add g to toggle
set hidden " When a buffer is brought to foreground, remember undo history and marks
set history=1000 " Increase history from 20 default to 1000
set hlsearch " Highlight searches
set ignorecase " Ignore case of searches
set incsearch " Highlight dynamically as pattern is typed
set laststatus=2 " Always show status line
set magic " Enable extended regex
set mouse=a " Enable mouse in all modes
set noerrorbells " Disable error bells
set nostartofline " Don't reset cursor to start of line when moving around
set showmode " Show the current mode
set nu " Enable line numbers
set ruler " Show the cursor position
set scrolloff=3 " Start scrolling three lines before horizontal border of window
set sidescrolloff=3 " Starting scrolling three lines before vertical border of window
set shiftwidth=2 " The # of spaces for indenting
set showtabline=2 " Alway show tab bar
set smartcase " Ignore 'ignorecase' if search patter contains uppercase characters
set smarttab " At start of line, <Tab> inserts shiftwidth spaces, <Bs> deletes shiftwidth spaces
set softtabstop=2 " Tab key results in 2 spaces

" Configuration ---------------------------------------------

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
	let g:airline_enable_syntastic = 1
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
	let g:syntastic_error_symbol = '✗'
	let g:syntastic_warning_symbold = '⚠'
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

call plug#end()
