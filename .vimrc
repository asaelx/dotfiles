"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|
"

call plug#begin()
    Plug 'tpope/vim-surround'
    Plug 'airblade/vim-gitgutter'
    Plug 'Valloric/YouCompleteMe'
    Plug 'kien/ctrlp.vim'
    Plug 'mattn/emmet-vim'
    Plug 'tpope/vim-commentary'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'townk/vim-autoclose'
    Plug 'mileszs/ack.vim'
    Plug 'chrisbra/colorizer'
    Plug 'vim-scripts/HTML-AutoCloseTag'
    Plug 'junegunn/goyo.vim'
    Plug 'dracula/vim', { 'as': 'dracula' }
    Plug 'ntk148v/vim-horizon'
call plug#end()

set number
set relativenumber

filetype on
syntax on
set termguicolors
set background=dark
colorscheme horizon

set hidden
set history=100
set undolevels=1000
set viminfo='20,<1000
set backspace=indent,eol,start

filetype indent on
"set nowrap
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set smartindent
set autoindent

set hlsearch
set smartcase
set ignorecase
set incsearch

set showmatch

set cursorline
hi CursorLine cterm=bold ctermbg=238 ctermfg=NONE
hi Search cterm=NONE ctermbg=205 ctermfg=15

autocmd BufRead,BufNewFile *.rb set shiftwidth=2

let user_emmet_expandabbr_key = '<c-e>'
let g:user_emmet_settings = {
\    'html' : {
\        'comment_type': 'lastonly'
\    }
\}

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
