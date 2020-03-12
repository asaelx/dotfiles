"          __
"  __  __ /\_\    ___ ___   _ __   ___
" /\ \/\ \\/\ \ /' __` __`\/\`'__\/'___\
" \ \ \_/ |\ \ \/\ \/\ \/\ \ \ \//\ \__/
"  \ \___/  \ \_\ \_\ \_\ \_\ \_\\ \____\
"   \/__/    \/_/\/_/\/_/\/_/\/_/ \/____/
"

call plug#begin()
    Plug 'tpope/vim-surround'
    Plug 'airblade/vim-gitgutter'
    Plug 'Valloric/YouCompleteMe'
    Plug 'kien/ctrlp.vim'
    Plug 'honza/vim-snippets'
    Plug 'mattn/emmet-vim'
    Plug 'sirver/ultisnips'
    Plug 'tomtom/tcomment_vim'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'alvan/vim-closetag'
    Plug 'mileszs/ack.vim'
    Plug 'chrisbra/colorizer'
    Plug 'junegunn/goyo.vim'
    Plug 'camspiers/animate.vim'
    Plug 'majutsushi/tagbar'
    Plug 'ntk148v/vim-horizon'
    Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
call plug#end()

set number
set relativenumber

filetype plugin indent on
syntax on
set termguicolors
set background=dark
colorscheme horizon

set hidden
set history=100
set undolevels=1000
set viminfo='20,<1000
set backspace=indent,eol,start

set nowrap
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

set splitbelow
set splitright
set cursorline
hi CursorLine cterm=bold ctermbg=238 ctermfg=NONE
hi Search cterm=NONE ctermbg=205 ctermfg=15

let user_emmet_expandabbr_key = '<c-e>'
let g:user_emmet_settings = {
\    'html' : {
\        'comment_type': 'lastonly'
\    }
\}

let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
