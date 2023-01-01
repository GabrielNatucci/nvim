" set guicursor=i:block
set nu
set nohlsearch
set tabstop=4 softtabstop=4
set shiftwidth=4

if exists('g:vscode')
    source $HOME/.config/nvim/vscode/vscode.vim
else
    source $HOME/.config/nvim/vim-plug/plugins.vim
    set exrc
    set relativenumber
    set hidden
    set noerrorbells
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

    set guifont=Hack\ Regular\ Nerd\ Font\ Complete\

    " atalhos
    let mapleader = " "
    nnoremap <leader>x :!chmod +x %<CR>
    nnoremap <silent> <c-k> :wincmd k<CR>
    nnoremap <silent> <c-j> :wincmd j<CR>
    nnoremap <silent> <c-h> :wincmd h<CR>
    nnoremap <silent> <c-l> :wincmd l<CR>

    " telescope
    nnoremap <leader>f :Telescope find_files<CR>

    " tree
    nnoremap <leader>e :NvimTreeToggle<CR>

    " Terminal
    nnoremap <leader>t :ToggleTerm direction=float<CR>
    nnoremap <leader>ht :ToggleTerm direction=horizontal<CR>
    :tnoremap <Esc> <C-\><C-n>

    " DAP
    nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
    nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
    nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
    nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
    nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
    nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
    nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
    nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
    nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>
endif
