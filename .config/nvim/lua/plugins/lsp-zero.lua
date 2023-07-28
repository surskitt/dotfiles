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
            { 'L3MON4D3/LuaSnip' },
            { 'hrsh7th/cmp-path' },
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
            -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

            require('lsp-zero.cmp').extend()

            -- And you can configure cmp even more, if you want to.
            local cmp = require('cmp')
            local cmp_action = require('lsp-zero.cmp').action()

            -- initialize global var to false -> nvim-cmp turned off per default
            vim.g.cmptoggle = false

            cmp.setup({
                enabled = function()
                    return vim.g.cmptoggle
                end,
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                    ['<Tab>'] = cmp_action.tab_complete(),
                    ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
                    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select_opts),
                    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select_opts),

                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                },
                preselect = 'item',
                completion = {
                    -- autocomplete = false,
                    completeopt = 'menu,menuone,noinsert'
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
            -- (Optional) Configure lua language server for neovim
            lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

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
                "lua_ls",
                "ruff_lsp",
                "rust_analyzer",
                "terraformls",
                "tflint",
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
                }
            })

            lsp.setup()
        end
    }
}
