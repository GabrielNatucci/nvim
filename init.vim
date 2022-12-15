if exists('g:vscode')
    set nu
    set nohlsearch
    set tabstop=4 softtabstop=4
    set shiftwidth=4
else
    source $HOME/.config/nvim/vim-plug/plugins.vim
    set exrc
    set relativenumber
    set nu
    set nohlsearch
    set hidden
    set noerrorbells 
    set tabstop=4 softtabstop=4
    set shiftwidth=4
    set expandtab
    set smartindent
    set nowrap
    set noswapfile
    set nobackup
    set undodir=~/.vim/undodir
    set incsearch
    set scrolloff=8
    set encoding=UTF-8
    set signcolumn=yes

    colorscheme tokyonight-storm

    set guifont=Hack\ Regular\ Nerd\ Font\ Complete\ 10
    
    " atalhos
    let mapleader = " "

    " telescope
    nnoremap <leader>f :Telescope find_files<CR>

    " tree
    nnoremap <leader>e :NvimTreeToggle<CR>

    " Terminal
    nnoremap <leader>t :ToggleTerm direction=float<CR>
endif
