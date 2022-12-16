call plug#begin()
    " theme
    Plug 'folke/tokyonight.nvim'
    Plug 'LunarVim/lunar.nvim'
    Plug 'projekt0n/github-nvim-theme'

    " auto pairs
    Plug 'jiangmiao/auto-pairs'

    " completion - lsp
    Plug 'L3MON4D3/LuaSnip'
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'rafamadriz/friendly-snippets'

    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'neovim/nvim-lspconfig'

    " debug
    Plug 'mfussenegger/nvim-dap'

    "utils
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'numToStr/Comment.nvim'
    Plug 'tamago324/lir.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'cappyzawa/trim.nvim'

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

    "Lua Line
    Plug 'nvim-lualine/lualine.nvim'
call plug#end()

lua <<EOF
    ---------------------------------------- MASON ---------------------------------------
    local lsp_config = require("lspconfig")
    local cmp = require("cmp")

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local general_on_attach = function(client, bufnr)
        if client.server_capabilities.completion then
            cmp.on_attach(client, bufnr)
        end
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', '<space>gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', '<space>gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', '<space>gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<space>wl', function()
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<space>d', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<space>rf', function() vim.lsp.buf.format { async = true } end, bufopts)
    end

    require("mason").setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    })

    require("mason-lspconfig").setup()
    require("mason-lspconfig").setup_handlers {
        function (server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup {
                capabilities = capabilities,
                on_attach = general_on_attach,
            }
        end,
    }

    ------------------------------------- COMPLETION - CMP -------------------------------------
    local kind_icons = {
        Text = "",
        Method = "m",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
    }
    cmp.setup({
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }, { "i" }),
            ["<tab>"] = cmp.mapping(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }, { "i" }),
            ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select }, { "i" }),
        }),
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                vim_item.menu = ({
                  luasnip = "[Snippet]",
                  buffer = "[Buffer]",
                  path = "[Path]",
                })[entry.source.name]
                return vim_item
            end,
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' }, -- For luasnip users.
        }, {
            { name = 'buffer' },
        })
    })

    cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
            { name = 'cmp_git' },
        }, {
            { name = 'buffer' },
        })
    })

    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        })
    })

    ---------------------------------- FRIENDLY-SNIPPETS ---------------------------------
    require("luasnip/loaders/from_vscode").lazy_load();

    ------------------------------------ Indent Lines ------------------------------------
    require("indent_blankline").setup {
        show_current_context = true,
        show_current_context_start = true,
    }
    ------------------------------------ TREE SITTER -------------------------------------
    require'nvim-treesitter.configs'.setup {
        auto_install = true,
        highlight = {
            enable = true,
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
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
        },
        hide_cursor = true,
        on_init = function()
            vim.api.nvim_buf_set_keymap(
                0,
                "x",
                "J",
                ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
                { noremap = true, silent = true }
            )

            vim.api.nvim_echo({ { vim.fn.expand("%:p"), "Normal" } }, false, {})
        end,
    }

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

    ----------------------------------- LUA LINE -----------------------------------
    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            }
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    }

    ----------------------------------- LUA LINE -----------------------------------
    require('trim').setup({
        -- if you want to ignore markdown file.
        -- you can specify filetypes.
        disable = {},
        -- if you want to remove multiple blank lines
        patterns = {
            [[%s/\(\n\n\)\n\+/\1/]],   -- replace multiple blank lines with a single line
        },
    })

    ----------------------------------- COMMENTS -----------------------------------
    require('Comment').setup()
EOF
