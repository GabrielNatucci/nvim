if exists('g:vscode')
    "Porcaria nenhuma
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

    colorscheme tokyonight-moon

    "set guifont=Ubuntu\ Nerd\ Font\ Complete\ 10
    set guifont=Hack\ Regular\ Nerd\ Font\ Complete\ 10

    let mapleader = " "
    nnoremap <leader>f :Telescope find_files<CR>
    nnoremap <leader>e :NvimTreeToggle<CR>
    nnoremap <leader>t :ToggleTerm direction=float<CR>
    nnoremap <leader>qf <Plug>(coc-fix-current)
    "nnoremap <leader>c gcc<CR>
    "
endif