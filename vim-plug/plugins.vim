call plug#begin()
    " theme
    Plug 'folke/tokyonight.nvim'

    " auto pairs
    Plug 'jiangmiao/auto-pairs'
    
    " coc
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " debug
    Plug 'mfussenegger/nvim-dap'
	
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'numToStr/Comment.nvim'
    Plug 'tamago324/lir.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    
    " telescope
    Plug 'nvim-telescope/telescope.nvim'
    
    " nvim tree
    Plug 'kyazdani42/nvim-tree.lua'
    
    " treesitter
    Plug 'nvim-treesitter/nvim-treesitter'
    
    "terminal
    Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}

    "Indent Lines
    Plug 'lukas-reineke/indent-blankline.nvim'
    
    "Image viewer
    Plug 'edluffy/hologram.nvim'
call plug#end()

lua <<EOF
    ------------------------------------ COC -------------------------------------
    -- Some servers have issues with backup files, see #649
    vim.opt.backup = false
    vim.opt.writebackup = false

    -- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
    -- delays and poor user experience
    vim.opt.updatetime = 300

    -- Always show the signcolumn, otherwise it would shift the text each time
    -- diagnostics appeared/became resolved
    vim.opt.signcolumn = "yes"

    local keyset = vim.keymap.set
    -- Autocomplete
    function _G.check_back_space()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
    end

    -- Use Tab for trigger completion with characters ahead and navigate
    -- NOTE: There's always a completion item selected by default, you may want to enable
    -- no select by setting `"suggest.noselect": true` in your configuration file
    -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
    -- other plugins before putting this into your config
    local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
    keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
    keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

    -- Make <CR> to accept selected completion item or notify coc.nvim to format
    -- <C-g>u breaks current undo, please make your own choice
    keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

    -- Use <c-j> to trigger snippets
    keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
    -- Use <c-space> to trigger completion
    keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

    -- Use K to show documentation in preview window
    function _G.show_docs()
        local cw = vim.fn.expand('<cword>')
        if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
            vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval('coc#rpc#ready()') then
            vim.fn.CocActionAsync('doHover')
        else
            vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
    end
    keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})


    -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
    vim.api.nvim_create_augroup("CocGroup", {})
    vim.api.nvim_create_autocmd("CursorHold", {
        group = "CocGroup",
        command = "silent call CocActionAsync('highlight')",
        desc = "Highlight symbol under cursor on CursorHold"
    })

    -- Symbol renaming
    keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})

    -- Setup formatexpr specified filetype(s)
    vim.api.nvim_create_autocmd("FileType", {
        group = "CocGroup",
        pattern = "typescript,json",
        command = "setl formatexpr=CocAction('formatSelected')",
        desc = "Setup formatexpr specified filetype(s)."
    })

    -- Update signature help on jump placeholder
    vim.api.nvim_create_autocmd("User", {
        group = "CocGroup",
        pattern = "CocJumpPlaceholder",
        command = "call CocActionAsync('showSignatureHelp')",
        desc = "Update signature help on jump placeholder"
    })

    ------------------------------------ Indent Lines ------------------------------------
    require("indent_blankline").setup {
        -- for example, context is off by default, use this to turn it on
        show_current_context = true,
        show_current_context_start = true,
    }

    ------------------------------------ TREE SITTER ------------------------------------
    require'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all"
        -- Install parsers synchronously (only applied to `ensure_installed`)
        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,
        -- List of parsers to ignore installing (for "all")
        -- ignore_install = { "javascript" },
        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
        highlight = {
            -- `false` will disable the whole extension
            enable = true,
            -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
            -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
            -- the name of the parser)
            -- list of language that will be disabled
            -- disable = { "c", "rust" },
            -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
    }

    ------------------------------------ NVIM TREE ------------------------------------
    require'nvim-tree'.setup{
        renderer = {
            indent_markers = {
                enable = true,
                icons = {
                    corner = "└ ",
                    edge = "│ ",
                    item = "│ ",
                    none = "  ",
                },
            },
            icons = {
                webdev_colors = true,
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = false,
                    git = true
                },
                glyphs = {
                    default = "",
                    symlink = "",
                    folder = {
                        arrow_closed = "",
                        arrow_open = "",
                        default = "",
                        open = "",
                        empty = "",
                        empty_open = "",
                        symlink = "",
                        symlink_open = "",
                    },
                    git = {
                        unstaged = "", -- 
                        staged = "",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "",
                        deleted = "",
                        ignored = "◌",
                    },
                },
            }
        },
        diagnostics = {
            enable = true,
            show_on_dirs = false,
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
            },
        }
    }

    ------------------------------------ TERMINAL -------------------------------------
    require("toggleterm").setup{}

    ----------------------------------- lir -----------------------------------
    local actions = require'lir.actions'
    local mark_actions = require 'lir.mark.actions'
    local clipboard_actions = require'lir.clipboard.actions'

    require'lir'.setup {
      show_hidden_files = false,
      devicons_enable = true,
      mappings = {
        ['l']     = actions.edit,
        ['<C-s>'] = actions.split,
        ['<C-v>'] = actions.vsplit,
        ['<C-t>'] = actions.tabedit,

        ['h']     = actions.up,
        ['q']     = actions.quit,

        ['K']     = actions.mkdir,
        ['N']     = actions.newfile,
        ['R']     = actions.rename,
        ['@']     = actions.cd,
        ['Y']     = actions.yank_path,
        ['.']     = actions.toggle_show_hidden,
        ['D']     = actions.delete,

        ['J'] = function()
          mark_actions.toggle_mark()
          vim.cmd('normal! j')
        end,
        ['C'] = clipboard_actions.copy,
        ['X'] = clipboard_actions.cut,
        ['P'] = clipboard_actions.paste,
      },
      float = {
        winblend = 0,
        curdir_window = {
          enable = false,
          highlight_dirname = false
        },

        -- -- You can define a function that returns a table to be passed as the third
        -- -- argument of nvim_open_win().
        -- win_opts = function()
        --   local width = math.floor(vim.o.columns * 0.8)
        --   local height = math.floor(vim.o.lines * 0.8)
        --   return {
        --     border = {
        --       "+", "─", "+", "│", "+", "─", "+", "│",
        --     },
        --     width = width,
        --     height = height,
        --     row = 1,
        --     col = math.floor((vim.o.columns - width) / 2),
        --   }
        -- end,
      },
      hide_cursor = true,
      on_init = function()
        -- use visual mode
        vim.api.nvim_buf_set_keymap(
          0,
          "x",
          "J",
          ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
          { noremap = true, silent = true }
        )

        -- echo cwd
        vim.api.nvim_echo({ { vim.fn.expand("%:p"), "Normal" } }, false, {})
      end,
    }

    -- custom folder icon
    require'nvim-web-devicons'.set_icon({
      lir_folder_icon = {
        icon = "",
        color = "#7ebae4",
        name = "LirFolderNode"
      }
    })

    ----------------------------------- Image Viwer/hologram -----------------------------------
    require('hologram').setup{
        auto_display = true -- WIP automatic markdown image display, may be prone to breaking
    }

EOF
