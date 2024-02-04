return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        lazy = true,
        config = function()
            -- This is where you modify the settings for lsp-zero
            -- Note: autocompletion settings will not take effect

            require('lsp-zero.settings').preset({})
        end
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',

            'hrsh7th/cmp-nvim-lua',
            -- snippets with LuaSnip
            {
                'L3MON4D3/LuaSnip',
                config = function()
                    require("luasnip").config.setup {
                        updateevents = "TextChanged,TextChangedI",
                    }
                    require("snippets")
                end,
            },
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',

            'onsails/lspkind.nvim',
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
            -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

            require('lsp-zero.cmp').extend()

            -- And you can configure cmp even more, if you want to.
            local cmp = require('cmp')
            local cmp_action = require('lsp-zero.cmp').action()
            local luasnip = require('luasnip')

            require("luasnip.loaders.from_vscode").lazy_load()

            -- initialize global var to false -> nvim-cmp turned off per default
            vim.g.cmptoggle = true

            cmp.setup({
                enabled = function()
                    return vim.g.cmptoggle
                end,
                mapping = {
                    ['<C-l>'] = cmp.mapping.confirm({ select = false }),
                    -- ['<Tab>'] = cmp_action.tab_complete(),
                    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select_opts),
                    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select_opts),

                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

                    ['<Tab>'] = cmp_action.luasnip_supertab(),
                    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),

                    -- ["<Tab>"] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_next_item()
                    --         -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                    --         -- they way you will only jump inside the snippet region
                    --     elseif luasnip.expand_or_locally_jumpable() then
                    --         luasnip.expand_or_jump()
                    --         -- elseif has_words_before() then
                    --         --     cmp.complete()
                    --     else
                    --         fallback()
                    --     end
                    -- end, { "i", "s" }),
                    --
                    -- ["<S-Tab>"] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_prev_item()
                    --     elseif luasnip.jumpable(-1) then
                    --         luasnip.jump(-1)
                    --     else
                    --         fallback()
                    --     end
                    -- end, { "i", "s" }),
                },
                preselect = 'item',
                completion = {
                    -- autocomplete = false,
                    completeopt = 'menu, menuone, noinsert'
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    {
                        name = "luasnip",
                        -- keyword_length = 3
                    },
                    -- { name = "nvim_lua" },
                    -- { name = 'nvim_lsp_document_symbol' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = "path" },
                    {
                        name = "buffer",
                        keyword_length = 7
                    },
                }),
                formatting = {
                    fields = { 'abbr', 'kind', 'menu' },
                    format = require('lspkind').cmp_format({
                        mode = 'symbol_text',
                        maxwidth = 50,
                        ellipsis_char = '...',
                    })
                }
            })

            vim.keymap.set("n", "<leader>tc", "<cmd>lua vim.g.cmptoggle = not vim.g.cmptoggle<CR>",
                { desc = "toggle nvim-cmp" })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = 'LspInfo',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'williamboman/mason.nvim' },
        },
        config = function()
            -- This is where all the LSP shenanigans will live

            local lsp = require('lsp-zero')

            lsp.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp.default_keymaps({ buffer = bufnr })
            end)

            local lspconfig = require('lspconfig')

            lsp.set_sign_icons({
                error = '✘',
                warn = '▲',
                hint = '⚑',
                info = '»'
            })

            lsp.ensure_installed({
                "ansiblels",
                "bashls",
                "golangci_lint_ls",
                "gopls",
                "jsonls",
                "lua_ls",
                "ruff_lsp",
                "rust_analyzer",
                "terraformls",
                "tflint",
                "yamlls",
            })

            lsp.format_on_save({
                format_opts = {
                    async = false,
                    timeout_ms = 10000,
                },
                servers = {
                    ['ansible'] = { 'ansiblels' },
                    ['bash'] = { 'bashls' },
                    ['gopls'] = { 'go' },
                    ['lua_ls'] = { 'lua' },
                    ['python'] = { 'ruff_lsp' },
                    ['rust_analyzer'] = { 'rust' },
                    ['terraformls'] = { 'terraform' },
                    ['jsonls'] = { 'json' },
                }
            })

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            lspconfig.lua_ls.setup({
                lsp.nvim_lua_ls(),
                capabilities = capabilities
            })

            lspconfig.terraformls.setup({
                capabilities = capabilities
            })

            lsp.setup()
        end
    }
}
