call plug#begin()
    " theme
    Plug 'folke/tokyonight.nvim'
    Plug 'LunarVim/lunar.nvim'
    Plug 'projekt0n/github-nvim-theme'
    Plug 'joshdick/onedark.vim'
    Plug 'xiyaowong/nvim-transparent'

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
    Plug 'mfussenegger/nvim-jdtls'

    " debug
    Plug 'mfussenegger/nvim-dap'

    "utils
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'tpope/vim-commentary'
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

    "Lua Line
    Plug 'nvim-lualine/lualine.nvim'

    "which key
    Plug 'folke/which-key.nvim'
call plug#end()

lua <<EOF
    ---------------------------------------- MASON ---------------------------------------
    local lsp_config = require("lspconfig")
    local cmp = require("cmp")
    local root_pattern = require'lspconfig'.util.root_pattern
    local capabilities = vim.lsp.protocol.make_client_capabilities()

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
                -- root_dir = root_pattern('.git'),
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
        {
            name = 'path',
            option = {
                trailing_slash = true,
            },
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

    ----------------------------------- TRIM -----------------------------------
    require('trim').setup({
        -- if you want to ignore markdown file.
        -- you can specify filetypes.
        disable = {},
        -- if you want to remove multiple blank lines
        patterns = {
            [[%s/\(\n\n\)\n\+/\1/]],   -- replace multiple blank lines with a single line
        },
    })

    ----------------------------------- WHICHKEY -----------------------------------
    require("which-key").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }

    ----------------------------------- DAP -----------------------------------
    local dap = require'dap'
    dap.adapters.cpp = {
        type = 'executable',
        command = 'lldb-vscode',
        env = {
            LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"
        },
        name = "lldb"
    }

    dap.configurations.cpp = {
        {
            name = "Launch",
            type = "cpp",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            args = {}
        }
    }
    dap.configurations.c = dap.configurations.cpp

    ----------------------------------- JAVA-JDTLS -----------------------------------
    -- local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

    -- local config = {
    --     cmd = {
    --         'java',
    --         '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    --         '-Dosgi.bundles.defaultStartLevel=4',
    --         '-Declipse.product=org.eclipse.jdt.ls.core.product',
    --         '-Dlog.protocol=true',
    --         '-Dlog.level=ALL',
    --         '-Xms1g',
    --         '--add-modules=ALL-SYSTEM',
    --         '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    --         '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    --         '-jar', '/home/natucci/Library/Java/jdt-language-server-1.7.0-202112161541/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
    --         '-configuration', '/home/natucci/Library/Java/jdt-language-server-1.7.0-202112161541/config_linux/',

    --         '-data', vim.fn.expand('~/.cache/jdtls-workspace').. workspace_dir,
    --     },

    --     root_dir = vim.fs.dirname(vim.fs.find({'.gradlew', '.git', 'mvnw'}, { upward = true })[1]),
    -- }

    -- require('jdtls').start_or_attach(config)

    ----------------------------------- TRANSPARENT -----------------------------------
    require("transparent").setup({
        enable = true, -- boolean: enable transparent
        extra_groups = { -- table/string: additional groups that should be cleared
            "BufferLineTabClose",
            "BufferlineBufferSelected",
            "BufferLineFill",
            "BufferLineBackground",
            "BufferLineSeparator",
            "BufferLineIndicatorSelected",
        },
        exclude = {}, -- table: groups you don't want to clear
    })
EOF
