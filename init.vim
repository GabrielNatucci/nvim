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

    "set guifont=Ubuntu\ Nerd\ Font\ Complete\ 10
    set guifont=Hack\ Regular\ Nerd\ Font\ Complete\ 10

    let mapleader = " "
    " telescope
    nnoremap <leader>f :Telescope find_files<CR>

    " tree
    nnoremap <leader>e :NvimTreeToggle<CR>

    " Terminal
    nnoremap <leader>t :ToggleTerm direction=float<CR>

    " COC
    nnoremap <leader>qf <Plug>(coc-fix-current)
    nnoremap <leader>d :<C-u>CocList diagnostics<CR>
    nnoremap <leader>ac  <Plug>(coc-codeaction-cursor)
    nnoremap <leader>gd  <Plug>(coc-definition)
    nnoremap <leader>gt  <Plug>(coc-type-definition)
    nnoremap <leader>re <Plug>(coc-codeaction-refactor)   
endif
