}
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

" Ale
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_linters = {'javascript': ['']}
let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_use_local_config = 1

" Deoplete
let g:deoplete#enable_at_startup = 1

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
