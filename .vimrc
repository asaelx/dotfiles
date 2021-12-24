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
    Plug 'scrooloose/nerdtree'
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
    Plug 'junegunn/limelight.vim'
    Plug 'camspiers/animate.vim'
    Plug 'majutsushi/tagbar'
    Plug 'matze/vim-move'
    Plug 'ntk148v/vim-horizon'
    Plug 'embark-theme/vim', { 'as': 'embark' }
call plug#end()

set number
set relativenumber

filetype plugin indent on
syntax on
set termguicolors
set background=dark
colorscheme embark

set hidden
set history=500
set undolevels=1000
set viminfo='20,<1000
set nobackup
set nowb
set noswapfile
set backspace=indent,eol,start
set whichwrap+=<,>,h,l

" set nowrap
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

set lazyredraw
set wildmenu

set splitbelow
set splitright
set cursorline

set noerrorbells
set novisualbell
set t_vb=
set tm=500

let mapleader = ","

map <space> /

nmap <leader>w :w!<cr>
nmap <leader>q :q!<cr>

let user_emmet_expandabbr_key = '<c-e>'
let g:user_emmet_settings = {
\    'html' : {
\        'comment_type': 'lastonly'
\    }
\}

let g:UltiSnipsExpandTrigger='<c-j>'
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'

let g:move_key_modifier = 'S'

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
