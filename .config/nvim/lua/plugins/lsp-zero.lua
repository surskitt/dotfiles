-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

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
        event = { 'InsertEnter', 'CmdlineEnter' },
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
                end,
            },
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',

            'onsails/lspkind.nvim',

            {
                "Saecki/crates.nvim",
                event = { "BufRead Cargo.toml" },
                config = function()
                    require("crates").setup({
                        src = {
                            cmp = {
                                enabled = true,
                            },
                        },
                        null_ls = {
                            enabled = true,
                            name = "crates.nvim",
                        },
                    })
                end
            },
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
            -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

            require('lsp-zero.cmp').extend()

            -- And you can configure cmp even more, if you want to.
            local cmp = require('cmp')
            local cmp_action = require('lsp-zero.cmp').action()
            local lspkind = require('lspkind')

            local luasnip = require('luasnip')
            luasnip.add_snippets(nil, {
                go     = require("plugins.luasnip.go"),
                sh     = require("plugins.luasnip.shell"),
                python = require("plugins.luasnip.python"),
            })
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
                    { name = "crates" },
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

            vim.keymap.set("n", "<leader>sc", "<cmd>lua vim.g.cmptoggle = not vim.g.cmptoggle<CR>",
                { desc = "toggle nvim-cmp" })

            -- `/` cmdline setup.
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            -- `:` cmdline setup.
            -- cmp.setup.cmdline(':', {
            --     mapping = cmp.mapping.preset.cmdline(),
            --     sources = cmp.config.sources({
            --         { name = 'path' }
            --     }, {
            --         {
            --             name = 'cmdline',
            --             option = {
            --                 ignore_cmds = { 'Man', '!' }
            --             }
            --         }
            --     })
            -- })

            cmp.setup.cmdline(":", {
                -- completion = {
                --     autocomplete = false,
                -- },
                mapping = cmp.mapping.preset.cmdline({
                    ["<C-k>"] = cmp.mapping({
                        c = function(fallback)
                            if cmp.visible() then
                                return cmp.select_prev_item()
                            end
                            fallback()
                        end,
                    }),
                    ["<C-j>"] = cmp.mapping({
                        c = function(fallback)
                            if cmp.visible() then
                                return cmp.select_next_item()
                            end
                            fallback()
                        end,
                    }),
                    ["<C-l>"] = cmp.mapping({
                        c = function()
                            if cmp.visible() then
                                return cmp.confirm()
                            end
                            fallback()
                        end,
                    }),
                }),
                sources = {
                    { name = "path" },
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!" },
                        },
                    },
                },
                formatting = {
                    fields = { "abbr", "kind" },
                    format = lspkind.cmp_format({
                        mode = "symbol_text", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
                        maxwidth = 50,        -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        before = function(_, vim_item)
                            if vim_item.kind == "Variable" then
                                vim_item.kind = ""
                                return vim_item
                            end
                            -- just show the icon
                            vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or
                                vim_item.kind
                            return vim_item
                        end,
                    }),
                },
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline({
                    ["<C-k>"] = cmp.mapping({
                        c = function(fallback)
                            if cmp.visible() then
                                return cmp.select_prev_item()
                            end
                            fallback()
                        end,
                    }),
                    ["<C-j>"] = cmp.mapping({
                        c = function(fallback)
                            if cmp.visible() then
                                return cmp.select_next_item()
                            end
                            fallback()
                        end,
                    }),
                    ["<C-l>"] = cmp.mapping({
                        c = function(fallback)
                            if cmp.visible() then
                                return cmp.confirm({
                                    behavior = cmp.ConfirmBehavior.Replace, -- e.g. console.log -> console.inlog -> console.info
                                    select = true,                          -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                                })
                            else
                                return fallback()
                            end
                        end,
                    }),
                }),
                sources = {
                    { name = "buffer" },
                },
                formatting = {
                    fields = { "abbr", "kind" },
                    format = lspkind.cmp_format({
                        mode = "symbol_text", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
                        maxwidth = 50,        -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        before = function(_, vim_item)
                            if vim_item.kind == "Text" then
                                vim_item.kind = ""
                                return vim_item
                            end
                            -- just show the icon
                            vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or
                                vim_item.kind
                            return vim_item
                        end,
                    }),
                },
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = 'LspInfo',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'williamboman/mason-lspconfig.nvim',
            'williamboman/mason.nvim',
            'nvim-lua/plenary.nvim',
            'nvimtools/none-ls.nvim',
            {
                'b0o/SchemaStore.nvim',
                version = false
            },
            'someone-stole-my-name/yaml-companion.nvim',
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
                "marksman",
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
                    ['ansiblels'] = { 'ansible' },
                    ['bashls'] = { 'bash' },
                    ['jsonls'] = { 'json', 'json5' },
                    ['lua_ls'] = { 'lua' },
                    ['null-ls'] = { 'go', 'markdown' },
                    ['ruff_lsp'] = { 'python' },
                    ['rust_analyzer'] = { 'rust' },
                    ['terraformls'] = { 'terraform' },
                }
            })

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            lspconfig.lua_ls.setup({
                lsp.nvim_lua_ls(),
                capabilities = capabilities,
                on_init = function(client)
                    local path = client.workspace_folders[1].name
                    if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                        client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                            Lua = {
                                runtime = {
                                    version = 'LuaJIT'
                                },
                                workspace = {
                                    checkThirdParty = false,
                                    library = {
                                        vim.env.VIMRUNTIME
                                    }
                                }
                            }
                        })

                        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                    end
                    return true
                end
            })

            lspconfig.terraformls.setup({
                capabilities = capabilities
            })

            lspconfig.yamlls.setup(
                require("yaml-companion").setup({
                    -- detect k8s schemas based on file content
                    builtin_matchers = {
                        kubernetes = { enabled = true }
                    },

                    schemas = {
                        {
                            name = "Kustomization",
                            uri = "https://json.schemastore.org/kustomization.json"
                        },
                        {
                            name = "GitHub Workflow",
                            uri = "https://json.schemastore.org/github-workflow.json"
                        },
                    },

                    lspconfig = {
                        settings = {
                            yaml = {
                                validate = true,
                                schemaStore = {
                                    enable = false,
                                    url = ""
                                },

                                schemas = require('schemastore').yaml.schemas {
                                    select = {
                                        'kustomization.yaml',
                                        'GitHub Workflow',
                                    }
                                }
                            }
                        }
                    }
                })
            )

            lspconfig.jsonls.setup {
                capabilities = capabilities,
                filetypes = { "json", "jsonc", "json5" },
                settings = {
                    json = {
                        schemas = require('schemastore').json.schemas {
                            select = {
                                'Renovate',
                                'GitHub Workflow Template Properties'
                            }
                        },
                        validate = { enable = true },
                    }
                },
                handlers = {
                    ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
                        -- jsonls doesn't really support json5
                        -- remove some annoying errors
                        if string.match(result.uri, "%.json5$", -6) and result.diagnostics ~= nil then
                            local idx = 1
                            while idx <= #result.diagnostics do
                                -- "Comments are not permitted in JSON."
                                if result.diagnostics[idx].code == 521 then
                                    table.remove(result.diagnostics, idx)
                                else
                                    idx = idx + 1
                                end
                            end
                        end
                    end,
                },
            }

            lsp.setup()

            local null_ls = require('null-ls')
            local null_opts = lsp.build_options('null-ls', {})

            null_ls.setup({
                on_attach = function(client, bufnr)
                    null_opts.on_attach(client, bufnr)
                end,
                sources = {
                    null_ls.builtins.formatting.goimports,
                    null_ls.builtins.diagnostics.markdownlint,
                    null_ls.builtins.formatting.terraform_fmt,
                    null_ls.builtins.diagnostics.terraform_validate,
                }
            })
        end
    }
}
