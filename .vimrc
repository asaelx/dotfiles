set number
set relativenumber

filetype on
syntax on

set hidden
set history=100
set undolevels=1000
set viminfo='20,<1000

filetype indent on
set nowrap
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent

set hlsearch
set smartcase
set ignorecase
set incsearch

set showmatch

set cursorline
hi CursorLine cterm=NONE ctermbg=234 ctermfg=NONE

call plug#begin()
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-fugitive'
    Plug 'Valloric/YouCompleteMe'
    Plug 'kien/ctrlp.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'mattn/emmet-vim'
    Plug 'tpope/vim-commentary'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'severin-lemaignan/vim-minimap'
    Plug 'townk/vim-autoclose'
    Plug 'mileszs/ack.vim'
call plug#end()

let user_emmet_expandabbr_key = '<c-e>'
let g:user_emmet_settings = {
\    'html' : {
\        'comment_type': 'lastonly'
\    }
\}
